@captured @python_candidate
Feature: excel charts native behavior capture

  These candidate descriptions need central reconciliation.
  Captured text grants no execution credit.

  @candidate-python-excel-charts-9c06992bdc
  # Native: tests/test_excel_charts.py::TestExcelCharts::test_adds_chart
  Scenario: Native check: adds chart [TestExcelCharts]
    Given Create an instance of ExcelAdvancedTools.
    And an isolated writable temporary directory
    And wb.save with temp dir under "chart.xlsx"
    And ws title is set to "Data"
    And path is prepared as temp dir under "chart.xlsx"
    When excel advanced tools.tool excel add chart using file path str representation of temp dir under "chart.xlsx"; data range "Data!A1:B4"; chart type "line"; title "Trend"; position "E2"
    Then result field "success" is true
    And the number of entries in ws charts equals 1
