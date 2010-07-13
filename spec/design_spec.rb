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

      javascript = <<EOT
function(doc){
  if(doc.tags){
    for(var tag in doc.tags){
      emit(doc.tags[tag], 1);
    }
  }
}
EOT
      map_reduce = {'map' => javascript}

      begin
        test_design = MyDesign.find_by_name('testview')
      rescue
        test_design = MyDesign.new('name' => 'testview')
      end

      test_design.views['tags'] = CouchAr::View.new('tags', test_design, map_reduce)
      test_design.save!

      books = Book.find_by_view(test_design.views['tags'])
      books[test_tag].size.should == 1
      books[test_tag][0].id.should == b.id
    end
  end
end
