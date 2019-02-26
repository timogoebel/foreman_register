# frozen_string_literal: true

module ForemanRegister
  class RegistrationToken
    class << self
      def encode(host, secret)
        payload = prepare_payload(host, secret)
        new JWT.encode(payload, secret)
      end

      private

      def prepare_payload(host, secret)
        iat = Time.now.to_i # Issued At
        exp = Time.now.advance(hours: 24).to_i # Expiration Time
        nbf = Time.now.to_i - 3600 # Not Before Time
        jti_raw = [secret, iat].join(':')
        jti = Digest::SHA256.hexdigest(jti_raw) # JWT ID
        {
          host_id: host.id,
          iat: iat,
          jti: jti,
          exp: exp,
          nbf: nbf
        }
      end
    end

    attr_reader :token

    def initialize(token)
      @token = token
    end

    def decode
      return nil if token.blank?
      return nil if secret.blank?

      payload = JWT.decode(token, secret)
      payload.first
    end

    def to_s
      token
    end

    private

    def secret
      @secret ||= find_secret
    end

    def find_secret
      host = ForemanRegister::RegistrationFacet.find_by(host_id: unsecure_payload['host_id'])&.host
      facet = host.registration_facet!
      facet.jwt_secret
    end

    def unsecure_payload
      # This does not validate the token secret to extract the host id so we can find the
      # corresponding jwt secret. We store an individual secret for every host so we can
      # revoke the issued tokens by changing the secret.
      @unsecure_payload ||= JWT.decode(token, nil, false).first
    end
  end
end