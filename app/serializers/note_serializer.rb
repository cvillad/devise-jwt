class NoteSerializer
  include JSONAPI::Serializer
  attributes :title, :body, :slug
  belongs_to :user
end