class Notification < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :message

  # for sorting: organisations_sorted = Organisation.all.sort
  def <=> (other_notification)
    # il '-' ed il 'to_i' mi servono per l'ordinamento contrario :)
    -self.date.to_i <=> -other_notification.date.to_i
  end
end
