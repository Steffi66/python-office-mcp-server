@captured @python_candidate
Feature: azure pricing tools native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-azure-pricing-tools-fbda452c74
  # Native: tests/test_azure_pricing_tools.py::test_service_alias_resolves_to_cached_name
  Scenario: Native check: service alias resolves to cached name
    Given tools is prepared as the result of AzurePricingTools with no arguments
    And service is prepared as "API Management"
    And region is prepared as "westeurope"
    And currency is prepared as "USD"
    And AzurePricingTools price cache at the result of cache key with "API Management"; "westeurope"; "USD" is set to the entries the fields "serviceName" set to "API Management", "productName" set to "API Management", "skuName" set to "Developer", "armSkuName" set to "Developer", "meterName" set to "Consumption", "retailPrice" set to 1.23, "unitOfMeasure" set to "1 Hour", "type" set to "Consumption"
    When tools.tool azure query prices using service "Azure API Management"; region "westeurope"; currency "USD"
    Then result field "service" equals "API Management"
    And result field "service_requested" equals "Azure API Management"
    And result field "count" equals 1

  @candidate-python-azure-pricing-tools-537bb07a41
  # Native: tests/test_azure_pricing_tools.py::test_fabric_tier_calculation_uses_cu_mapping
  Scenario: Native check: fabric tier calculation uses cu mapping
    Given tools is prepared as the result of AzurePricingTools with no arguments
    And service is prepared as "Microsoft Fabric"
    And region is prepared as "westeurope"
    And currency is prepared as "USD"
    And AzurePricingTools price cache at the result of cache key with "Microsoft Fabric"; "westeurope"; "USD" is set to the entries the fields "serviceName" set to "Microsoft Fabric", "productName" set to "Fabric Capacity", "skuName" set to "Fabric Capacity", "armSkuName" set to "Fabric_Capacity_CU_Hour", "meterName" set to "CU Hour", "retailPrice" set to 0.18, "unitOfMeasure" set to "1 CU-Hour", "type" set to "Consumption"
    When tools.tool azure calculate cost using service "Azure Fabric"; region "westeurope"; currency "USD"; sku match "F64"; quantity 1; hours per month 1
    Then result field "fabric_tier" equals "F64"
    And result field "fabric_cu" equals 64
    And result field "effective_quantity" equals 64
    And result field "monthly_cost" equals the result of pytest.approx with 0.18 repeated by 64; rel 1e-06

  @candidate-python-azure-pricing-tools-a0661afda2
  # Native: tests/test_azure_pricing_tools.py::test_list_services_from_cache_only
  Scenario: Native check: list services from cache only
    Given tools is prepared as the result of AzurePricingTools with no arguments
    And region is prepared as "westeurope"
    And currency is prepared as "USD"
    And AzurePricingTools price cache at the result of cache key with "Service Bus"; "westeurope"; "USD" is set to [{"serviceName": "Service Bus"}]
    And AzurePricingTools price cache at the result of cache key with "Key Vault"; "westeurope"; "USD" is set to [{"serviceName": "Key Vault"}]
    When tools.tool azure list services using region "westeurope"; currency "USD"; from cache only true
    Then result field "source" equals "cache"
    And set representation of result field "services", defaulting to [] is at least "{'Key Vault', 'Service Bus'}"
