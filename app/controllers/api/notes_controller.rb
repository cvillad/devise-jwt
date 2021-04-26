class Api::NotesController < ApiController
  def index 
    notes = Note.order(created_at: :desc)
    render json: serializer.new(notes)
  end

  def create 
  end

  def update 
  end

  def destroy 
  end

  private 
  
  def serializer 
    NoteSerializer
  end
end
