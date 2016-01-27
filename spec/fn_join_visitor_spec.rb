require_relative '../lib/cfn-toolkit/fn_join_visitor'

describe FnJoinVisitor do
  subject do
    FnJoinVisitor.new
  end

  it "returns an array as is" do
    expect(subject.visit_Fn__Join([], {})).to eq []
  end

  it "parses a string into fn join array" do
    expect(subject.visit_Fn__Join("a test with %{{Ref1}} and %{{Ref2}} and some more text", {})).to eq([
          "",
          [
            "a test with ",
            { "Ref" => "Ref1" },
            " and ",
            { "Ref" => "Ref2" },
            " and some more text"
          ]
      ])
  end

  it "parses AWS inbuilt references" do
    expect(subject.visit_Fn__Join("arn:aws:iam::%{{AWS::AccountId}}:saml-provider/myprovider", {})).to eq([
          "",
          [
            "arn:aws:iam::",
            { "Ref" => "AWS::AccountId" },
            ":saml-provider/myprovider"
          ]
      ])
  end
end
