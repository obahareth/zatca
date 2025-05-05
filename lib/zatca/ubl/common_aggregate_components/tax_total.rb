class ZATCA::UBL::CommonAggregateComponents::TaxTotal < ZATCA::UBL::BaseComponent
  # <cac:TaxTotal>
  #   <cbc:TaxAmount currencyID="SAR">97.5</cbc:TaxAmount>
  #   <cac:TaxSubtotal>
  #     <cbc:TaxableAmount currencyID="SAR">650.0</cbc:TaxableAmount>
  #     <cbc:TaxAmount currencyID="SAR">97.5</cbc:TaxAmount>
  #     <cac:TaxCategory>
  #       <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305">S</cbc:ID>
  #       <cbc:Percent>15</cbc:Percent>
  #       <cac:TaxScheme>
  #         <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153">VAT</cbc:ID>
  #       </cac:TaxScheme>
  #     </cac:TaxCategory>
  #   </cac:TaxSubtotal>
  #   <cac:TaxSubtotal>
  #     <cbc:TaxableAmount currencyID="SAR">650.0</cbc:TaxableAmount>
  #     <cbc:TaxAmount currencyID="SAR">0.00</cbc:TaxAmount>
  #     <cac:TaxCategory>
  #       <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305">Z</cbc:ID>
  #       <cbc:Percent>0.00</cbc:Percent>
  #       <cbc:TaxExemptionReasonCode>VATEX-SA-32</cbc:TaxExemptionReasonCode>
  #       <cbc:TaxExemptionReason>Zero rated due to exemption</cbc:TaxExemptionReason>
  #       <cac:TaxScheme>
  #         <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153">VAT</cbc:ID>
  #       </cac:TaxScheme>
  #     </cac:TaxCategory>
  #   </cac:TaxSubtotal>
  # </cac:TaxTotal>
  def initialize(
    tax_amount:,tax_subtotal_amount: nil, rounding_amount: nil, currency_id: "SAR", tax_category: nil, taxable_amount: nil, tax_subtotals: []
  )
    super()
    @tax_amount = tax_amount
    @rounding_amount = rounding_amount
    @tax_category = tax_category || ZATCA::UBL::CommonAggregateComponents::TaxCategory.new
    @currency_id = currency_id
    @taxable_amount = taxable_amount
    @tax_subtotal_amount = tax_subtotal_amount

    @tax_subtotals = if @taxable_amount.present? && @tax_subtotal_amount.present? && @tax_category.present? && tax_subtotals.blank?
      [
        ZATCA::UBL::CommonAggregateComponents::TaxSubtotal.new(
          taxable_amount: @taxable_amount,
          tax_amount: @tax_subtotal_amount,
          tax_category: @tax_category,
          currency_id: @currency_id
        )
      ]
    else
      tax_subtotals
    end
  end

  def name
    "cac:TaxTotal"
  end

  def rounding_amount_element
    if @rounding_amount.present?
      ZATCA::UBL::BaseComponent.new(name: "cbc:RoundingAmount", value: @rounding_amount, attributes: {"currencyID" => @currency_id})
    end
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(
        name: "cbc:TaxAmount",
        value: @tax_amount,
        attributes: { "currencyID" => @currency_id }
      ),
      rounding_amount_element,
      *@tax_subtotals # each is a TaxSubtotal and responds to `#name` and `#elements`
    ].compact
  end
end
