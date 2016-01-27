require_relative '../lib/cfn-toolkit/cfn_template_hash'

describe CfnTemplateHash do
  subject do
    CfnTemplateHash.create(h, merge_dir)
  end

  let(:h) do
    {
      "Fn::Join" => "a%{{test}}here"
    }
  end

  context "No merge directory given" do
    let(:merge_dir) { nil }

    it "doesnt merge any yaml" do
      expect(subject.to_h).to eq({
        "Fn::Join" => ["", ["a", {"Ref" => "test"}, "here"]]
      })
    end
  end

  context "merge directory" do
    let(:merge_dir) { '/app' }

    before do
      expect(Dir).to receive(:[]).with('/app/**/*.yml').and_return(['1'])
      expect(YAML).to receive(:load_file).with('1').and_return({"Another" => "Item"})
    end

    it "merges in yaml" do
      expect(subject.to_h).to eq({
        "Another"  => "Item",
        "Fn::Join" => ["", ["a", {"Ref" => "test"}, "here"]]
      })
    end
  end
end
