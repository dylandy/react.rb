require "spec_helper"

describe React do
  describe "is_valid_element" do
    it "should return true if passed a valid element" do
      element = React::Element.new(`React.createElement('div')`)
      expect(React.is_valid_element(element)).to eq(true)
    end
    
    it "should return false is passed a non React element" do
      element = React::Element.new(`{}`)
      expect(React.is_valid_element(element)).to eq(false)
    end
  end
  
  describe "create_element" do
    it "should create a valid element with only tag" do
      element = React.create_element('div')
      expect(React.is_valid_element(element)).to eq(true)
    end
    
    context "with block" do
      it "should create a valid element with text as only child when block yield String" do
        element = React.create_element('div') { "lorem ipsum" }
        expect(React.is_valid_element(element)).to eq(true)
        expect(element.props.children).to eq("lorem ipsum")
      end
      
      it "should create a valid element with children as array when block yield Array of element" do
        element = React.create_element('div') do
          [React.create_element('span'), React.create_element('span'), React.create_element('span')]
        end
        expect(React.is_valid_element(element)).to eq(true)
        expect(element.props.children.length).to eq(3)
      end
    end
    describe "custom element" do
      before do
        stub_const 'Foo', Class.new
        Foo.class_eval do
          def render
            React.create_element("div") { "lorem" }
          end
        end
      end
      
      it "should create a valid element provided class defined `render`" do
        element = React.create_element(Foo)
        expect(React.is_valid_element(element)).to eq(true)
      end
      
      it "should raise error if provided class doesn't defined `render`" do
        expect { React.create_element(Array) }.to raise_error
      end
    end
    pending "element with properties"
  end
  
  
  describe "render" do
    async "should render element to DOM" do
      div = `document.createElement("div")`
      React.render(React.create_element('span') { "lorem" }, div) do
        run_async {
          expect(`div.children[0].tagName`).to eq("SPAN")
          expect(`div.textContent`).to eq("lorem")
        }
      end
    end
    
    it "should work without providing a block" do
      div = `document.createElement("div")`
      React.render(React.create_element('span') { "lorem" }, div)
    end
    
    pending "should return nil to prevent abstraction leakage" do
      div = `document.createElement("div")`
      expect {
        React.render(React.create_element('span') { "lorem" }, div)
      }.to be_nil
    end
  end
  
  describe "render_to_String" do
    it "should render a React.Element to string" do
      ele = React.create_element('span') { "lorem" }
      expect(React.render_to_string(ele)).to be_kind_of(String)
    end
  end
  
end