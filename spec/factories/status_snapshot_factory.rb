
FactoryGirl.define do
  factory :status_snapshot do

    # TODO: make this valid
    raw_json "{}"
    failed false
    version "50"

    tree { FactoryGirl.build :root_status_node }

    factory :failed_status_snapshot do
      failed true
      error_message "It was extremely invalid"
      raw_json nil
    end
  end
end
