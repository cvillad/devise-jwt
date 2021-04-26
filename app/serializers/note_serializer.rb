class NoteSerializer
  include JSONAPI::Serializer
  attributes :title, :body
end