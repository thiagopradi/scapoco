require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Scapoco::BulkInsert do
  let(:bulk_insert) { Scapoco::BulkInsert.new(Post) }

  context "#save!" do
    it "allows to do bulk insert" do
      bulk_insert.data << { title: "foo", text: "foo",  flag: 1 }
      bulk_insert.data << { title: "OMG", text: "text", flag: 2 }
      expect { bulk_insert.save! }.to change(Post, :count).by(+2)
    end
  end

  context "#attribute_list" do
    it "should return a list of all attributes, ordered" do
      bulk_insert.attribute_list.should == ["flag", "text", "title"]
    end
  end

  context "#values_for_insert" do
    it "should iterate over all data, and join correctly" do
      bulk_insert.data << { title: "foo", text: "bar", flag:1 }
      bulk_insert.values_for_insert.should == "(1, 'bar', 'foo', '#{Time.now.utc.to_formatted_s(:db)}', '#{Time.now.utc.to_formatted_s(:db)}')"
    end
  end

  context "#cast_value" do
    it "should return the correct casted value for integer" do
      bulk_insert.cast_value(1).should == '1'
    end

    it "should return the correct casted value for strings" do
      bulk_insert.cast_value("teste").should == "'teste'"
    end

    it "should return the correct casted value for dates" do
      bulk_insert.cast_value(Date.new(2012, 02, 03)).should == "'2012-02-03'"
    end
  end
end
