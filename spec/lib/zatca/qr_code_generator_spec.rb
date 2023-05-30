describe ZATCA::QRCodeGenerator do
  let(:tags_generator) { ZATCA::QRCodeGenerator.new(tags: ZATCA::Tags.new(FIXTURES_TAGS)) }
  let(:base64_generator) { ZATCA::QRCodeGenerator.new(base64: FIXTURES_BASE64_QR_CODE) }

  describe "#render" do
    it "returns a base64 data_url when given ZATCA::Tags" do
      rendered_code = tags_generator.render
      expected_rendered_code = "data:image/png;base64,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"

      expect(rendered_code).to eq(expected_rendered_code)
    end

    it "returns a base64 data_url when given ZATCA::Tags" do
      rendered_code = base64_generator.render
      expected_rendered_code = "data:image/png;base64,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"

      expect(rendered_code).to eq(expected_rendered_code)
    end
  end
end
