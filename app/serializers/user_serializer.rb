class UserSerializer
  include JSONAPI::Serializer
  attributes :email, JsonWebToken.encode(sub: :id)
end