package com.devsecops.calculator_cicd.instance;

public record InstanceResponse(
        String application,
        String version,
        String instance,
        String port
) {
}
