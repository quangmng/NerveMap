//
//  Dermatome.swift
//  NrvMap 3D
//
//  Created by Wendy Zhou on 10/4/2025.
//

import SwiftUI

/// A model representing a single dermatome.
struct Dermatome: Identifiable {
    let id: Int
    let nerveLevel: String
    let area: String
    let clinicalNote: String
}

/// A comprehensive list of dermatomes from C2 through S5.
let allDermatomes: [Dermatome] = [
    Dermatome(
        id: 0,
        nerveLevel: "V",
        area: "Face areas",
        // TODO: - Waiting for Toby's professional fill-in
        clinicalNote: ""
    ),
    Dermatome(
        id: 1,
        nerveLevel: "C2",
        area: "Posterior scalp near the occipital protuberance",
        clinicalNote: "Sensory deficits here may indicate upper cervical involvement."
    ),
    Dermatome(
        id: 2,
        nerveLevel: "C3",
        area: "Lower neck and upper posterior neck region",
        clinicalNote: "Often tested in the supraclavicular fossa."
    ),
    Dermatome(
        id: 3,
        nerveLevel: "C4",
        area: "Lower neck, upper shoulders, over AC joint",
        clinicalNote: "Crucial for shoulder region sensory distribution."
    ),
    Dermatome(
        id: 4,
        nerveLevel: "C5",
        area: "Lateral shoulder (deltoid area)",
        clinicalNote: "Known as the 'regimental badge' region."
    ),
    Dermatome(
        id: 5,
        nerveLevel: "C6",
        area: "Lateral forearm and thumb",
        clinicalNote: "Evaluate radial side sensory deficits."
    ),
    Dermatome(
        id: 6,
        nerveLevel: "C7",
        area: "Posterior arm, forearm, and middle finger",
        clinicalNote: "Key location for C7 radiculopathy."
    ),
    Dermatome(
        id: 7,
        nerveLevel: "C8",
        area: "Medial forearm, ring and little fingers",
        clinicalNote: "Involvement indicates lower cervical nerve issues."
    ),
    Dermatome(
        id: 8,
        nerveLevel: "T1",
        area: "Medial side of forearm, near the axilla",
        clinicalNote: "Often tested in the antecubital fossa."
    ),
    Dermatome(
        id: 9,
        nerveLevel: "T2",
        area: "Upper chest, apex of axilla",
        clinicalNote: "Sensory changes may affect upper chest region."
    ),
    Dermatome(
        id: 10,
        nerveLevel: "T3",
        area: "Third intercostal space (upper chest)",
        clinicalNote: "Less commonly referenced clinically."
    ),
    Dermatome(
        id: 11,
        nerveLevel: "T4",
        area: "Nipple line (4th intercostal space)",
        clinicalNote: "Common landmark for thoracic dermatomes."
    ),
    Dermatome(
        id: 12,
        nerveLevel: "T5",
        area: "Mid-chest area just below the nipples",
        clinicalNote: "Often overlaps with T4 and T6."
    ),
    Dermatome(
        id: 13,
        nerveLevel: "T6",
        area: "Level of the xiphoid process",
        clinicalNote: "Reference point for the lower chest region."
    ),
    Dermatome(
        id: 14,
        nerveLevel: "T7",
        area: "Subcostal area (~1/4 from xiphoid to umbilicus)",
        clinicalNote: "Used to track mid-thorax sensory changes."
    ),
    Dermatome(
        id: 15,
        nerveLevel: "T8",
        area: "Halfway between xiphoid process and umbilicus",
        clinicalNote: "Location can vary among individuals."
    ),
    Dermatome(
        id: 16,
        nerveLevel: "T9",
        area: "Three-quarters from xiphoid to umbilicus",
        clinicalNote: "Overlaps T8 and T10 distributions."
    ),
    Dermatome(
        id: 17,
        nerveLevel: "T10",
        area: "Umbilical region (belly button)",
        clinicalNote: "Classic site for T10 radiculopathy testing."
    ),
    Dermatome(
        id: 18,
        nerveLevel: "T11",
        area: "Lower abdomen, between umbilicus and groin",
        clinicalNote: "Transition zone from T10 to T12."
    ),
    Dermatome(
        id: 19,
        nerveLevel: "T12",
        area: "Just above the inguinal ligament area",
        clinicalNote: "Marks the lower trunk boundary."
    ),
    Dermatome(
        id: 20,
        nerveLevel: "L1",
        area: "Groin region and upper hip area",
        clinicalNote: "First lumbar dermatome near the inguinal region."
    ),
    Dermatome(
        id: 21,
        nerveLevel: "L2",
        area: "Anterior and medial thigh",
        clinicalNote: "Key for proximal thigh sensation."
    ),
    Dermatome(
        id: 22,
        nerveLevel: "L3",
        area: "Medial knee and lower thigh",
        clinicalNote: "Check for knee extension deficits."
    ),
    Dermatome(
        id: 23,
        nerveLevel: "L4",
        area: "Medial lower leg, medial malleolus",
        clinicalNote: "Involved in patellar reflex; medial ankle region."
    ),
    Dermatome(
        id: 24,
        nerveLevel: "L5",
        area: "Lateral leg, dorsum of foot, big toe",
        clinicalNote: "Common site for sciatica or disc-related issues."
    ),
    Dermatome(
        id: 25,
        nerveLevel: "S1",
        area: "Lateral foot and heel",
        clinicalNote: "Often linked to sciatic nerve involvement."
    ),
    Dermatome(
        id: 26,
        nerveLevel: "S2",
        area: "Posterior thigh, popliteal fossa",
        clinicalNote: "Assessed for hamstring region sensation."
    ),
    Dermatome(
        id: 27,
        nerveLevel: "S3",
        area: "Buttock area, genitals",
        clinicalNote: "Sensory changes can reflect sacral nerve issues."
    ),
    Dermatome(
        id: 28,
        nerveLevel: "S4",
        area: "Perianal region",
        clinicalNote: "Crucial for bowel/bladder innervation."
    ),
    Dermatome(
        id: 29,
        nerveLevel: "S5",
        area: "Perianal region (nearest the anus)",
        clinicalNote: "Lowest dermatome, important for sacral cord function."
    )
]
