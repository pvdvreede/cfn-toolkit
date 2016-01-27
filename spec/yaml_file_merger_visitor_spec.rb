require_relative '../lib/cfn-toolkit/yaml_file_merger_visitor'

describe YamlFileMergerVisitor do
  let(:hash) do
    {"Resources" => {"ResourceOne" => "Initial value"}}
  end

  subject do
    YamlFileMergerVisitor.new("/app/test")
  end

  before do
    expect(Dir).to receive(:[]).with("/app/test/**/*.yml").and_return(['1', '2'])
    expect(YAML).to receive(:load_file)
      .and_return({"Resources" => {"AnotherResource" => "includes value"}})
      .exactly(2).times
    subject.visit_template(hash)
  end

  it "correctly merges hash" do
    expect(hash).to eq({
          "Resources" => {
            "ResourceOne" => "Initial value",
            "AnotherResource" => "includes value"
          }
      })
  end
end
