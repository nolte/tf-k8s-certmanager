// +build integration

package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestIssuerSelfSignConfig(t *testing.T) {

	terraformOptions := &terraform.Options{
		TerraformDir: "../minimal",
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

}
func TestIssuerCAConfig(t *testing.T) {

	terraformOptions := &terraform.Options{
		TerraformDir: "../issuer_ca",
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

}
