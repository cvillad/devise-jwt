require 'rails_helper'

RSpec.describe Note, type: :model do
  describe "#validations" do 
    let(:note) {build :note}
    it "should validate factory" do 
      expect(note).to be_valid
    end

    it "should validate presence of title" do 
      note.title = nil
      expect(note).not_to be_valid 
      expect(note.errors[:title]).to include("can't be blank")
    end

    it "should validate presence of body" do 
      note.body = nil
      expect(note).not_to be_valid 
      expect(note.errors[:body]).to include("can't be blank")
    end

    it "should validate presence of slug" do 
      note.slug = nil
      expect(note).not_to be_valid 
      expect(note.errors[:slug]).to include("can't be blank")
    end

    it "should validate uniqueness of slug" do 
      another_note = create :note, slug: note.slug
      expect(note).not_to be_valid 
      expect(note.errors[:slug].first).to include("already been taken")
    end

    it "should validate presence of user" do 
      note.user = nil 
      expect(note).not_to be_valid 
      expect(note.errors[:user]).to include("must exist")
    end
  end
end
