class Api::NotesController < ApiController
  def index 
    notes = Note.order(created_at: :desc)
    render json: serializer.new(notes)
  end

  def create 
    note = current_user.notes.build(note_params)
    note.save!
    render json: serializer.new(note)
  end

  def update 
  end

  def destroy 
  end

  private 
  
  def serializer 
    NoteSerializer
  end

  def note_params
    params.dig(:data, :attributes)&.permit(:title, :body)
  end
end
