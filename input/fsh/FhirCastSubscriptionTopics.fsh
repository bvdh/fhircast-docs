// Instance: FhirCastTopicSubscrioptionTopic
// InstanceOf: SubscriptionTopic
// * url = "http://fhircast.hl7.org/container-update/topic"
// * version = #0.1.0
// * title = "FHIRcast topic based container updates"
// * status = #active
// * experimental = true
// * date = "2022-02-17"
// * description = """
// FHIRcast container updates when content in the current anchor of a type for a topic changes. The SubscriptionTopic holds filter 
// parameters that all indication of the topic and anchor-type. The topic corresponds to the FHIRcast topic which context is used, the
// anchor-type indicates the resource-type of context elements. When resources in the container of this anchor-type change, the subscription
// will be triggered.
// """
// * eventTrigger
//   * description = "A change in the container of the resource of an anchor-type of the indicated topic"
// * canFilterBy[+}.searchParamName = "topic"
// * canFilterBy[=}.searchModifier = #eq
// * canFilterBy[=}.documentation = "filters to events for a specific topic"
// * canFilterBy[+}.searchParamName = "anchor-type"
// * canFilterBy[=}.searchModifier = #eq
// * canFilterBy[=}.documentation = "filters to events for a specific anchor type"

// Instance: FhirCastContainerSubscriptionTopic
// InstanceOf: SubscriptionTopic
// * url = "http://fhircast.hl7.org/container-update/resource"
// * version = "0.1.0"
// * title = "Resourcecontainer updates"
// * description = "Updates are send when a resource changes in the container of one of the indicated resources."
// * status = #active
// * experimental = true
// * date = "2022-02-17"
// * eventTrigger
//   * description = "A change in the container of one of the specified resources"
// * canFilterBy[+}.searchParamName = "resource-id"
// * canFilterBy[=}.searchModifier = #eq
// * canFilterBy[=}.documentation = """
// filters to events for a specific resource (reference))
// """
