package test

import (
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

const domain = "example.com"

// An example of how to test the simple Terraform module in examples/terraform-basic-example using Terratest.
func TestTerraformBasicExample(t *testing.T) {
	t.Parallel()

	testID := strings.ToLower(random.UniqueId())
	hostname := "test-" + testID

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic",
		Vars: map[string]interface{}{
			"hostname":        hostname,
			"domain":          domain,
			"resource_suffix": "-" + hostname,
		},
		NoColor: true,
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	fqdn := terraform.Output(t, terraformOptions, "fqdn")

	expectedFQDN := hostname + "." + domain
	if fqdn != expectedFQDN {
		t.Errorf("Expected FQDB to be %s, got %s", expectedFQDN, fqdn)
	}
}
