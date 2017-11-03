class AddAttachmentCoverImageToLandingPages < ActiveRecord::Migration[5.1]
  def self.up
    change_table :landing_pages do |t|
      t.attachment :cover_image
    end
  end

  def self.down
    remove_attachment :landing_pages, :cover_image
  end
end
