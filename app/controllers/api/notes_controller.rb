class Api::NotesController < ApiController
  before_action :set_note, only: %i[update destroy]

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
    @note.update!(note_params.to_h)
    render json: serializer.new(@note)
  end

  def destroy 
  end

  private 
  
  def serializer 
    NoteSerializer
  end

  def note_params
    params.dig(:data, :attributes)&.permit(:title, :body, :slug)
  end

  def set_note 
    @note = current_user.notes.find_by_slug(params[:slug])
  end
end
