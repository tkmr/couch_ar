require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "CouchAr" do
  before :all do
    @test_db = TestDB.open
  end

  describe 'Design' do
    it 'should provide to access some views' do
      test_tag = "tag_#{rand}"

      b = Book.new
      b.name = 'The Computer book'
      b.tags = ['cpu', 'hdd', 'tech', test_tag]
      b.save!

      begin
        test_design = TestDesign.find_by_name('testview')
      rescue
        test_design = TestDesign.new('name' => 'testview')
      end

      test_design.add_view('tags') do
        map <<-EOT
          function(doc){
            if(doc.tags){
              for(var tag in doc.tags){
                emit(doc.tags[tag], 1);
              }
            }
          }
        EOT

        reduce <<-EOT
          function(keys, values) {
            var hash = {};
            for(var k in keys){
              if (hash[keys[k][0]])
                hash[keys[k][0]] += values[k];
              else
                hash[keys[k][0]] =  values[k];
            }
            return hash;
          }
        EOT
      end

      test_design.save!

      books = Book.find_by_view(test_design.views['tags'])
      books[test_tag].size.should == 1
      books[test_tag][0].id.should == b.id

      res = test_design.views['tags'].get
      res = res['rows'][0]['value']
      res['tech'].should == 1
    end
  end
end
