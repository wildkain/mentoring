# == Schema Information
#
# Table name: candidates
#
#  id                       :integer          not null, primary key
#  last_name                :string
#  first_name               :string
#  middle_name              :string
#  registration_address     :string
#  home_address             :string
#  phone_number             :string
#  email                    :string
#  birth_date               :date
#  confession               :string
#  health_status            :string
#  serious_diseases         :string
#  work_start_date          :date
#  work_end_date            :date
#  organization_name        :string
#  work_contacts            :string
#  work_position            :string
#  work_functions           :text
#  work_schedule            :string
#  hobby                    :text
#  martial_status           :string
#  house_type               :string
#  number_of_rooms          :string
#  peoples_for_room         :string
#  peoples                  :text
#  pets                     :string
#  program_role             :string
#  program_reason           :text
#  person_character         :text
#  person_information       :text
#  help_reason              :text
#  child_age                :string
#  child_gender             :string
#  child_character          :text
#  visit_frequency          :string
#  invalid_child            :boolean
#  alcohol                  :string
#  tobacco                  :string
#  psychoactive             :string
#  drugs                    :string
#  child_crime              :string
#  disabled_parental_rights :string
#  reports                  :boolean
#  photo_rights             :boolean
#  info_about_program       :string
#  state                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  state_comment            :text
#  russian_citizenship      :boolean
#

class Candidate < ActiveRecord::Base
  include AASM

  has_many :candidate_educations
  has_many :candidate_family_members
  has_many :candidate_children_experiences
  accepts_nested_attributes_for :candidate_educations
  accepts_nested_attributes_for :candidate_family_members
  accepts_nested_attributes_for :candidate_children_experiences

  validates_presence_of :first_name, :last_name, :middle_name, :registration_address, :home_address, :phone_number,
                        :email, :birth_date,  :confession, :social_links, :health_status, :serious_diseases, :organization_name, :work_contacts, :work_position, :work_functions, :work_schedule, :hobby,
                        :martial_status, :program_role,
                        :program_reason, :person_character, :person_information, :help_reason, :child_age, :child_gender,
                        :child_character, :visit_frequency, :alcohol, :tobacco, :psychoactive, :drugs,
                        :child_crime, :disabled_parental_rights, :info_about_program

  validates_inclusion_of :invalid_child, :reports, :photo_rights, :russian_citizenship, in: [true, false]
  validates :email, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/ }, uniqueness: { case_sensitive: false }
  # validates :number_of_rooms, numericality: { greater_than_or_equal_to: 1 }

  HEALTH_STATUSES = ['отлично', 'хорошо', 'средне', 'плохо']
  GENDERS = ['Мужской', 'Женский']
  CHILD_GENDERS = ['Мужской', 'Женский', 'Не имеет значения']
  EDUCATION_TYPES = ['Общеобразовательная школа', 'Университет, Институт, техникум', 'Дополнительные курсы, тренинги, семинары']
  MARTIAL_STATUSES = ['Женат (замужем)', 'Гражданский брак', 'Разведён (разведена)', 'Вдовец (вдова)', 'Не женат (не замужем)']
  HOUSE_TYPES = ['Квартира', 'Частный дом', 'Арендованное жильё']
  PROGRAM_ROLES = ['Наставника', 'Волонтёра', 'Партнёра (оказывать единоразовую/постоянную финансовую поддержку)']

  aasm column: :state, whiny_transitions: false do
    state :new, initial: true
    state :approved

    event :approve do
      after do
        generated_password = Devise.friendly_token.first(8)
        user = User.create(email: email, first_name: first_name, last_name: last_name, middle_name: middle_name, password: generated_password)
        user.add_role :mentor
        RegistrationMailer.welcome(user, generated_password).deliver_now
      end
      transitions from: :new, to: :approved
    end
  end

  def full_name
    "#{last_name} #{first_name} #{middle_name}"
  end

end
