This scenario introduces a section in which content sharing is integrated with FHIRcast using a FHIR server. Most often this is used in deployments where the applications are[ [launched using SMARTonFHIR](4-1-launch-scenarios.html#smart-on-fhir).

### General set-up

The set-up of this approach is presented in figure below.

```plantuml
component "FHIR server" as FHIR
component App1
component App2
component "FHIRcast hub" as Hub

App1 -down-> FHIR
App1 -down-> Hub
App2 -down-> FHIR
App2 -down-> Hub
```

In this set-up one or more applications are connected to the FHIRcast hub and the FHIR server. The FHIRcast hub is used to send *context* change event. The FHIR server is used to read and store content and send *content* change events.

The transactions between the applications and the FHIR server FHIRcast Hub are independent of each other but related to the same data.

### Content related transactions and notifications

An application that requires access to data, change data or create new data will do so using the normal [FHIR RESTful API](https://www.hl7.org/fhir/http.html). An application that requires notification of changes in the data will use the [FHIR Subscription mechanism](http://build.fhir.org/subscriptions.html)[^note].

[^note] It is recommended that FHIR servers implement the new SubscriptionTopic based mechanism introduced in FHIR R4B and FHIR R5 although the older Subscription mechanism will work as well. In this specification we assume the new mechanism is used.

As content and context are separated, applications can still store content related to a previous context after the current context has changed.

In order to ease receiving Subscription updates related to the current context, it is RECOMMENDED that FHIR servers support the SubscriptionTopics defined in the sections below.

### FHIRcast SubscriptionTopics

The topics defined in this section use the following concepts::

* **Context** → what the user is working on, it is identified by the anchor resource (Patient, Encounter, ImagingStudy, DiagnosticReport, …​).
* **Content** → what is resources are generated/updated related to the context; all resources in the container of the context
* **Container** → all resources linked to the “anchor” resource, e.g. Patient, Encounter, ImagingStudy, DiagnosticReport. A resource is in the container if:
  * it is the anchor
  * referred to from the anchor
  * refers to the anchor

This is illustrated in the figure below.

```plantuml [Definition of Container]
package Container{
  class "Resource"  as anchor <<FHIR>>
  class "Resource"  as R1 <<FHIR>>
  class "Resource"  as R2 <<FHIR>>
}

note top of anchor
  Anchor resource = Context
end note

R1 -> "*" anchor
anchor -> "*" R2
```

#### Topic based subscriptions

A FHIR server supports Subscriptions on SubscriptionTopic with canonical:

> http://fhircast.hl7.org/container-update/topic

All Subscribers TopicBasedSubscriptionTopic will indicate the topic and, optionally, the list of anchor-types to like to receive updates when a resource in the current anchor of one of the anchor-types of the topic changes.

```text
Instance: FhirCastTopicSubscrioptionTopic
InstanceOf: SubscriptionTopic
* url = "http://fhircast.hl7.org/container-update/topic"
* version = #0.1.0
* title = "FHIRcast topic based container updates"
* status = #active
* experimental = true
* date = "2022-02-17"
* description = """
FHIRcast container updates when content in the current anchor of a type for a topic changes. The SubscriptionTopic holds filter 
parameters that all indication of the topic and anchor-type. The topic corresponds to the FHIRcast topic which context is used, the
anchor-type indicates the resource-type of context elements. When resources in the container of this anchor-type change, the subscription
will be triggered.
"""
* eventTrigger
  * description = "A change in the container of the resource of an anchor-type of the indicated topic"
* canFilterBy[+}.searchParamName = "topic"
* canFilterBy[=}.searchModifier = #eq
* canFilterBy[=}.documentation = "filters to events for a specific topic"
* canFilterBy[+}.searchParamName = "anchor-type"
* canFilterBy[=}.searchModifier = #eq
* canFilterBy[=}.documentation = "filters to events for a specific anchor type"
```

#### Container based subscriptions

A FHIR server supports Subscriptions on SubscriptionTopic with canonical:

> http://fhircast.hl7.org/container-update/resource

All Subscribers ContainerBasedSubscriptionTopic will indicate reference to the resource. Subscribers will receive updates when a resource in the container of this resource changes.

```text
Instance: FhirCastContainerSubscriptionTopic
InstanceOf: SubscriptionTopic
* url = "http://fhircast.hl7.org/container-update/resource"
* version = "0.1.0"
* title = "Resourcecontainer updates"
* description = "Updates are send when a resource changes in the container of one of the indicated resources."
* status = #active
* experimental = true
* date = "2022-02-17"
* eventTrigger
  * description = "A change in the container of one of the specified resources"
* canFilterBy[+}.searchParamName = "resource-id"
* canFilterBy[=}.searchModifier = #eq
* canFilterBy[=}.documentation = """
filters to events for a specific resource (reference))
"""
```

### Relation to Content Sharing for Radiology

The FHIR server based content exchange approach supports all use cases discussed in the [Content Sharing for Radiology](4-6-content-sharing.html) section by subscribing to the one of the `SubscriptionTopic`'s indicated before. Either using the anchor-type DiagnosticReport or a reference to current DiagnosticeReport.

When a resource is created, changed or deleted, a subscription notification will be send and the application can act accordingly.