require_relative '../lib/cfn-toolkit/stack_running_parser'

describe 'Parser for stack create or update cli options' do
  let(:options) { opts_parser }
  it 'parses the key value of params and tags' do
    expect(options.parse(%w[--params k=v,a=b --tags c=d]).to_h).to eq({
      tags: [
        { key: 'c', value: 'd'},
      ],
      params: [
        { key: 'k', value: 'v'},
        { key: 'a', value: 'b'}
      ]
    })
  end
end
