require 'spec_helper.rb'

describe Venice::InAppReceipt do

  describe ".new" do

    let :attributes do
      {
        "quantity" => 1,
        "product_id" => "com.foo.product1",
        "transaction_id" => "1000000070107235",
        "purchase_date" => "2014-05-28 14:47:53 Etc/GMT",
        "original_transaction_id" => "140xxx867509",
        "original_purchase_date" => "2014-05-28 14:47:53 Etc/GMT",
        "is_trial_period" => 'false',
        "version_external_identifier" => "123",
        "app_item_id" => 'com.foo.app1',
        "expires_date" => "2014-06-28 07:47:53 America/Los_Angeles",
        "cancellation_date" => "2014-06-28 14:47:53 Etc/GMT",
        'cancellation_reason' => '0'
      }
    end

    subject(:in_app_receipt) do
      Venice::InAppReceipt.new attributes
    end

    its(:quantity) { 1 }
    its(:product_id) { "com.foo.product1" }
    its(:transaction_id) { "1000000070107235" }
    its(:app_item_id) { 'com.foo.app1' }
    its(:version_external_identifier) { "123" }
    its(:original_transaction_id) { "140xxx867509" }
    its(:original_purchase_date) { should be_instance_of DateTime }
    its(:expires_date) { should be_instance_of DateTime }
    its(:purchase_date) { should be_instance_of DateTime }
    its(:cancellation_date) { should be_instance_of DateTime }
    its(:cancellation_reason) { '0' }

    it "should output a hash with attributes" do
      in_app_receipt.to_h.should include(
        :app_item_id => "com.foo.app1",
        :cancellation_date => "Sat, 28 Jun 2014 14:47:53 GMT",
        :cancellation_reason => '0',
        :expires_date => "Sat, 28 Jun 2014 07:47:53 GMT",
        :original_purchase_date => "Wed, 28 May 2014 14:47:53 GMT",
        :original_transaction_id => "140xxx867509",
        :product_id => "com.foo.product1",
        :purchase_date => "Wed, 28 May 2014 14:47:53 GMT",
        :quantity => 1,
        :transaction_id => "1000000070107235",
        :version_external_identifier => "123"
      )
    end


  end

end
