class ZATCA::UBL::CommonAggregateComponents::TaxSubtotal < ZATCA::UBL::BaseComponent
# This class represents the <cac:TaxSubtotal> component used within <cac:TaxTotal> blocks.
# According to ZATCA e-invoicing specifications, invoices must include two distinct <cac:TaxTotal> sections:
# 1. One summarizing the overall tax amount.
# 2. Another containing one or more <cac:TaxSubtotal> entries, each describing tax details by category.
#
# Each <cac:TaxSubtotal> element must correspond to a specific tax category (e.g., 'S' for standard rate, 'Z' for zero rate).
# This class enables the creation of multiple subtotal entries, ensuring proper grouping and structure for VAT breakdowns
# in compliance with ZATCA Phase 2 XML UBL formatting.

# <cac:TaxTotal> --> this tag for total invoice i think.
#   <cbc:TaxAmount currencyID="SAR">30.15</cbc:TaxAmount>
# </cac:TaxTotal>
# <cac:TaxTotal> --> this tag must hold taxSubtotals
#   <cbc:TaxAmount currencyID="SAR">30.15</cbc:TaxAmount>
#   <cac:TaxSubtotal>
#     <cbc:TaxableAmount currencyID="SAR">201.00</cbc:TaxableAmount>
#     <cbc:TaxAmount currencyID="SAR">30.15</cbc:TaxAmount>
#     <cac:TaxCategory>
#       <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305">S</cbc:ID>
#       <cbc:Percent>15.00</cbc:Percent>
#       <cac:TaxScheme>
#         <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153">VAT</cbc:ID>
#       </cac:TaxScheme>
#     </cac:TaxCategory>
#   </cac:TaxSubtotal>
#   <cac:TaxSubtotal>
#     <cbc:TaxableAmount currencyID="SAR">201.00</cbc:TaxableAmount>
#     <cbc:TaxAmount currencyID="SAR">30.15</cbc:TaxAmount>
#     <cac:TaxCategory>
#       <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305">S</cbc:ID>
#       <cbc:Percent>15.00</cbc:Percent>
#       <cac:TaxScheme>
#         <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153">VAT</cbc:ID>
#       </cac:TaxScheme>
#     </cac:TaxCategory>
#   </cac:TaxSubtotal>
# </cac:TaxTotal>

  def initialize(taxable_amount:, tax_amount:, tax_category:, currency_id: "SAR")
    super()
    @taxable_amount = taxable_amount
    @tax_amount = tax_amount
    @tax_category = tax_category || ZATCA::UBL::CommonAggregateComponents::TaxCategory.new
    @currency_id = currency_id
  end

  def name
    "cac:TaxSubtotal"
  end

  def elements
    [
      ZATCA::UBL::BaseComponent.new(name: "cbc:TaxableAmount", value: @taxable_amount, attributes: { "currencyID" => @currency_id }),
      ZATCA::UBL::BaseComponent.new(name: "cbc:TaxAmount", value: @tax_amount, attributes: { "currencyID" => @currency_id }),
      @tax_category
    ]
  end
end
