This section describes how FHIRcast can be used in a scenario where multiple applications subscribe to different anchor-types and still share context.

Examples of multiple coexisting anchor types are:

* Patient & Encounter, the patient is the subject of the Encounter.
* Patient, Encounter, ImagingStudy and Diagnostic report in a radiology use case where a radiologist works on a diagnostic report of an imaging study for a patient within an encounter.

### Main and derived context

The [FHIRcast context change events](3-Events.html) reflect this concept in the Context field. Each context-change event holds the resources that are currently in context.  `Patient-open` and `Patient-close` hold the patient context. `Encounter-open` and `-close` hold the encounter and patient context. The encounter is called the main context, patient is a derived context. An overview of main and derived contexts for different context change events is given in the table below.

| anchor-type | main context | derived context |
|-------------|--------------|-----------------|
| Patient     | patient | |
| Encounter   | encounter | patient |
| ImagingStudy | imagingstudy | encounter, patient |
| DiagnosticReport | imagingstudy | encounter, patient |

The challenge is to keep the overall context in sync.

### Controller and followers

Applications operating in a multi-anchor environment can be divided in controllers and followers. Controller applications change context (send `-open` and `-close` events), follower applications listen to context changes and act accordingly. Applications can be controller of some anchor-types and follow others.

Follower applications SHALL follow context changes indicated by Controller applications or indicate so by indicating a `syncerror`.

Controller application SHALL only send context-change events of resources that are in scope of anchor-types they follow. When the current resource of a derived context changes they SHALL change context of the anchor-types they for which they are controller accordingly, or indicate refusal by sending an sync-error.

An application that is controller for ImagingStudy may be a follower for Patient and Encounter. Which means it indicates what ImagingStudy is selected, but only ImagingStudies of the current Patient within context of the current Encounter.
When the Patient or Encounter changes, it will close the current ImagingStudy.

This also implies that when there are no controllers in the network for the base anchor-types, these will not be selected.

### Example flow

#### EHR select encounter and patient, Viewer ImagingStudy

EHR opens Encounter E1 of patient P1

{% include img.html img="MultiAnchorExample1-step1.svg" caption="Figure: Multi Anchor Example step 1" %}

Viewer searches for ImagingStudies within this context.

When the patient is closed, the ImagingStudy is closed as well.

{% include img.html img="MultiAnchorExample1-step2.svg" caption="Figure: Multi Anchor Example step 2" %}
