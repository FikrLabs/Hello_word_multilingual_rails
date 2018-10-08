require 'rails_helper'
require 'locale_helpers'
require 'yaml'


describe 'Mission returns title and instructions by language' do

  it 'should save the model with id' do
    record = Mission.create!({title: 'title', instructions: 'instructions', duration: 10, category: 'category'})

    expect(record.errors[:title].length).to eql(0)
    expect(record.errors[:instructions].length).to eql(0)
  end

  it 'should save the title to the locale' do
    reset_locale 'en_test'
    record = Mission.create!({title: 'demo_test_title', instructions: 'instructions', duration: 10, category: 'category'})

    yml_hash = YAML.load(File.read(yml_path('en_test')))
    expect(yml_hash['en_test']['missions']["m_#{record.id.to_s}"][:title]).to eql('demo_test_title')
  ensure
    remove_locale_file 'en_test'
  end

  it 'should save the instructions to the locale' do
    reset_locale 'en_test'
    record = Mission.create!({title: 'demo_test_title', instructions: 'go up and down', duration: 10, category: 'category'})

    yml_hash = YAML.load(File.read(yml_path('en_test')))
    expect(yml_hash['en_test']['missions']["m_#{record.id.to_s}"][:instructions]).to eql('go up and down')
  ensure
    remove_locale_file 'en_test'
  end

  it 'reads the title correctly based on locale' do
    ar_title = 'daght'
    en_title = 'pushup'

    create_yml_file_for_locale_mission('ar_test', 1, ar_title, 'instructions')

    reset_locale 'en_test'
    record = Mission.create!({title: en_title, instructions: 'exercise', duration: 10, category: 'category'})

    reset_locale 'en_test'
    expect(record.title).to eql(en_title)

    reset_locale 'ar_test'
    expect(record.title).to eql(ar_title)
  ensure
    remove_locale_file 'en_test'
    remove_locale_file 'ar_test'
  end

  it 'reads the instructions correctly based on locale' do
    en_instructions = 'exercise'
    ar_instructions = 'tamarin'

    create_yml_file_for_locale_mission('ar_test', 1, 'ar_title', ar_instructions)

    reset_locale 'en_test'
    record = Mission.create!({title: 'en_title', instructions: en_instructions, duration: 10, category: 'category'})

    reset_locale 'en_test'
    expect(record.instructions).to eql(en_instructions)

    reset_locale 'ar_test'
    expect(record.instructions).to eql(ar_instructions)
  ensure
    remove_locale_file 'en_test'
    remove_locale_file 'ar_test'
  end

  it 'update title and instructions from locale ' do
    reset_locale 'en_test'
    record = Mission.create!({title: 'initial_title', instructions: 'initial_instruction', duration: 5, category: 'category'})

    expect(record.id).to be_truthy
    expect(record.title).to eql('initial_title')
    expect(record.instructions).to eql('initial_instruction')

    updated_record = Mission.find(record.id)

    updated_record.title = "modified_title"
    updated_record.instructions = "modified_instructions"
    updated_record.save

    expect(updated_record.id).to be_truthy
    expect(updated_record.title).to eql('modified_title')
    expect(updated_record.instructions).to eql('modified_instructions')

    updated_record = Mission.find(record.id)

    expect(updated_record.id).to be_truthy
    expect(updated_record.title).to eql('modified_title')
    expect(updated_record.instructions).to eql('modified_instructions')
  ensure
    remove_locale_file 'en_test'
  end


end