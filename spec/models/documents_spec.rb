require 'rails_helper'

RSpec.describe Document do
  let(:document) {Document.new}
  let(:@documents) {Document.order(:process_step)}
  let(:fdoc) {Document.first}
  
  it 'has been loaded the first db document modell' do
    expect(fdoc).to be_instance_of(Document)
  end

  it 'is not done because it is not finally uploaded' do
    expect(document.done?).to be_truthy
  end

  it 'has the minimum needed values filled' do
    expect(document.document_name).to be_nil #be_a(String)
    expect(document.pm_standard).to be_nil #be_a(String)
    expect(document.document_type).to be_nil #be_a(String)
    expect(document.process_step).to be_nil #be_a(String)
    expect(document.document_version).to be_nil #be_a(String)
    expect(document.document_timestamp).to be_nil #be_a(DateTime)
    expect(document.j_document).to be_nil
  end

  it 'templates where uploaded' do
    expect(@documents).not_to be_empty
  end

end
