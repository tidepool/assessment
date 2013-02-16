class AssessmentSerializer < ActiveModel::Serializer
  attributes :id, :guest_user, :date_taken, :status,  :aggregate_results, :stages,
             :results_ready, :big5_dimension, :holland6_dimension,
             :emo8_dimension

  has_one :profile_description
  has_one :user, embed: :ids

  def guest_user
    object.user.guest
  end

end
