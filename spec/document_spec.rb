require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "CouchAr" do
  before :all do
    @test_db = TestDB.open
  end

  describe 'Document' do
    it 'provide CRUD operations to CouchDB' do
      aut = {
        "name" => 'tatsuya',
        "age"  => 29
      }

      b = Book.new
      b.name = 'The book'
      b.author = aut
      b.tags = ['tech', 'free', 'pdf']
      b.save!

      b2 = Book.find(b.id)
      b2.name.should == 'The book'
      b2.author.should == aut
      b2.name = 'The super book'
      b2.save!
    end

    describe '.type' do
      it 'should assign classname' do
        pending
      end

      it 'should filter result of find single' do
        pending
      end

      it 'should filter result of find every' do
        pending
      end

      it 'should load an instance of target class when called find_or_create_resource_for' do
        b = Book.new
        b.name = 'Super test book1'
        b.author = Author.new(:name => 'tatsuya', :age => 22)
        b.save!

        b2 = Book.find(b.id)
        p b2

        b2.class.should == Book
        b2.name.should == b.name
        b2.author.name.should == 'tatsuya'
        b2.author.class.should == Author
      end
    end
  end
end
