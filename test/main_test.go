package test

import (
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// An example of how to test the simple Terraform module in examples/terraform-basic-example using Terratest.
func TestTerraformBasicExample(t *testing.T) {
	t.Parallel()

	testID := strings.ToLower(random.UniqueId())
	resourceSuffix := "test-" + testID

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "..",
		Vars: map[string]any{
			"environment":     "test",
			"resource_suffix": resourceSuffix,
		},
		NoColor: true,
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	functionName := terraform.Output(t, terraformOptions, "function_name")

	expectedFunctionName := "" + resourceSuffix
	if functionName != expectedFunctionName {
		t.Errorf("Expected function name to be %s, got %s", expectedFunctionName, functionName)
	}
}
