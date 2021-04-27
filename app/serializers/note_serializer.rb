class NoteSerializer
  include JSONAPI::Serializer
  attributes :title, :body
  belongs_to :user
end