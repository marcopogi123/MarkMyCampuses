import 'dart:io';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> globalSchedules = [];
String globalUserName = "User";
String globalUserProgram = "Program";
String globalYearLevel = "Year";
String globalPassword = "";
File? globalProfileImage;

final Map<String, dynamic> campusData = {
  "Building 1": {
    "bldgHint": "Administrative building near the Aurora Blvd entrance.",
    "floors": {
      "1st Floor": {
        "Seminar Room A": "Left side of the lobby near the glass doors.",
        "Seminar Room B": "Located directly behind Seminar Room A.",
        "Alumni": "Far end of the hallway past the Registrar.",
        "Telering": "The information assistance counter in the main lobby.",
      },
      "2nd Floor": {
        "AVR": "Audio Visual Room with blue doors near the accounting windows.",
      },
      "3rd Floor": {
        "AVR": "Located directly above the 2nd floor AVR.",
        "Library":
            "Turn right from the stairs; the main entrance is at the end.",
      },
    },
  },
  "Building 2": {
    "bldgHint": "Engineering and Architecture hub located behind Building 1.",
    "floors": {
      "1st Floor": {
        "SAO": "Student Affairs Office; look for the posters near the door.",
        "Mechanical engineering department":
            "Faculty office across the hall from SAO.",
      },
      "2nd Floor": {
        "College of business education department":
            "Left side of the stairwell entrance.",
        "Environmental and sanitary engineering department":
            "Right side of the stairwell entrance.",
      },
      "3rd Floor": {
        "Architecture department":
            "Large drafting hall with several drawing tables.",
      },
    },
  },
  "Building 3": {
    "bldgHint": "Academic building adjacent to the study hall.",
    "floors": {
      "1st Floor": {
        "No listed rooms": "General lobby area and student benches.",
      },
      "2nd Floor": {
        "No listed rooms": "Classroom hallway; check room numbers on the door.",
      },
      "3rd Floor": {"No listed rooms": "Upper floor lecture rooms."},
      "4th Floor": {"No listed rooms": "Quiet floor for senior classes."},
      "5th Floor": {
        "No listed rooms": "Highest lecture floor in this building.",
      },
    },
  },
  "Building 5": {
    "bldgHint":
        "Information Technology building; houses the computer laboratories.",
    "floors": {
      "1st Floor": {"Canteen": "Main food court area on the ground floor."},
      "2nd Floor": {
        "ITSO":
            "Information Technology Services; located at the center of the floor.",
        "Room 5201": "Computer Lab 1; first door on the left from the stairs.",
        "Room 5202": "Computer Lab 2; directly beside Room 5201.",
        "Room 5203": "Computer Lab 3; mid-hallway lab.",
        "Room 5204": "Computer Lab 4; across the hallway from lab 3.",
        "Room 5205": "Computer Lab 5; look for the glass window doors.",
        "Room 5206": "Computer Lab 6; near the faculty lockers.",
        "Room 5207": "General classroom; mid-hallway.",
        "Room 5208": "General classroom; mid-hallway.",
        "Room 5209": "Computer lab; end of the left wing corridor.",
        "Room 5210": "Computer lab; end of the left wing corridor.",
        "Room 5211": "Lecture room; end of the right wing corridor.",
        "Room 5212": "Lecture room; end of the right wing corridor.",
        "Room 5213": "Small lecture room near the fire exit stairs.",
        "Room 5214": "Small lecture room near the fire exit stairs.",
        "Room 5215": "Last room at the end of the back hallway.",
        "Comfort Room": "Located at the end of the main hallway.",
        "College of computer studies department":
            "The main CCS faculty office area.",
      },
      "3rd Floor": {
        "Room 5301": "First room on the left after exiting the stairwell.",
        "Room 5302": "General classroom near the front stairs.",
        "Room 5303": "Lecture room; 3rd floor wing.",
        "Room 5304": "Lecture room; 3rd floor wing.",
        "Room 5305": "Lecture room; 3rd floor wing.",
        "Room 5306": "Lecture room; 3rd floor wing.",
        "Room 5307": "Lecture room; 3rd floor wing.",
        "Room 5308": "Lecture room; 3rd floor wing.",
        "Room 5309": "Lecture room; 3rd floor wing.",
        "Room 5310": "Lecture room; 3rd floor wing.",
        "Room 5311": "Lecture room; 3rd floor wing.",
        "Room 5312": "Lecture room; 3rd floor wing.",
        "Room 5313": "Lecture room; 3rd floor wing.",
        "Room 5314": "Lecture room; 3rd floor wing.",
        "Room 5315": "Last classroom at the end of the hall.",
        "Comfort Room": "Located near the EE and ECE faculty offices.",
        "Electrical engineering department":
            "Look for the EE banner on the door.",
        "Electronics engineering department":
            "Located right next to the EE department.",
      },
      "4th Floor": {
        "Room 5401": "First room from the 4th floor stair landing.",
        "Room 5402": "4th floor lecture room.",
        "Room 5403": "4th floor lecture room.",
        "Room 5404": "4th floor lecture room.",
        "Room 5405": "4th floor lecture room.",
        "Room 5406": "4th floor lecture room.",
        "Room 5407": "4th floor lecture room.",
        "Room 5408": "4th floor lecture room.",
        "Room 5409": "4th floor lecture room.",
        "Room 5410": "4th floor lecture room.",
        "Room 5411": "4th floor lecture room.",
        "Room 5412": "4th floor lecture room.",
        "Room 5413": "4th floor lecture room.",
        "Room 5414": "4th floor lecture room.",
        "Room 5415": "Last classroom on the 4th floor wing.",
        "Comfort Room": "Located near the IE and CpE departments.",
        "Industrial engineering department":
            "Faculty office with IE project displays.",
        "Computer engineering department":
            "CpE main office at the end of the hall.",
      },
    },
  },
  "Building 6": {
    "bldgHint": "Health and wellness building located near the PE center.",
    "floors": {
      "1st Floor": {
        "Clinic": "Main school clinic for medical assistance.",
        "Prayer Room": "Quiet space for reflection beside the clinic.",
      },
      "2nd Floor": {
        "No listed rooms": "Access hallway to the back building area.",
      },
      "3rd Floor": {"No listed rooms": "General classroom floor."},
      "4th Floor": {"No listed rooms": "Upper classroom floor."},
    },
  },
  "Building 8": {
    "bldgHint": "The Annex building for library and research expansion.",
    "floors": {
      "2nd Floor": {"Library": "Quiet study area with book stacks."},
      "3rd Floor": {"Library": "Internet station and research section."},
    },
  },
  "Building 9": {
    "bldgHint": "The tallest building on campus; hub for SHS and CAS.",
    "floors": {
      "1st Floor": {
        "Seminar Room 9": "Large ground floor hall for assemblies.",
        "College of Arts department":
            "CAS faculty office; look for the banners.",
        "Comfort Room": "Located near the SHS main office.",
        "Senior high school department": "Main administrative office for SHS.",
      },
      "2nd Floor": {
        "Room 9201": "First classroom door near the left stairs.",
        "Room 9202": "2nd floor classroom.",
        "Room 9203": "2nd floor classroom.",
        "Room 9204": "2nd floor classroom.",
        "Room 9205": "2nd floor classroom.",
        "Room 9206": "2nd floor classroom.",
        "Room 9207": "2nd floor classroom.",
        "Room 9208": "2nd floor classroom.",
        "Room 9209": "End of the hallway near the math office.",
        "Comfort Room": "Located in the middle of the floor wing.",
        "Math and physics department": "The primary science faculty office.",
      },
      "3rd Floor": {
        "Room 9301": "Classroom near the 3rd floor upper lobby.",
        "Room 9302": "3rd floor classroom.",
        "Room 9303": "3rd floor classroom.",
        "Room 9304": "3rd floor classroom.",
        "Room 9305": "3rd floor classroom.",
        "Room 9306": "3rd floor classroom.",
        "Room 9307": "3rd floor classroom.",
        "Room 9308": "3rd floor classroom.",
        "Room 9309": "End of the 3rd-floor hallway wing.",
        "Comfort Room": "Located in the middle of the floor wing.",
        "College of education department":
            "Faculty office for Education students.",
      },
      "4th Floor": {
        "Room 9401": "Classroom on the 4th level.",
        "Room 9402": "4th floor classroom.",
        "Room 9403": "4th floor classroom.",
        "Room 9404": "4th floor classroom.",
        "Room 9405": "4th floor classroom.",
        "Room 9406": "4th floor classroom.",
        "Room 9407": "4th floor classroom.",
        "Room 9408": "4th floor classroom.",
        "Room 9409": "Corner room overlooking the PE grounds.",
        "Comfort Room": "Mid-hallway comfort room.",
      },
      "5th Floor": {
        "Room 9501": "Top floor classroom; highest room in Bldg 9.",
        "Room 9502": "5th floor classroom.",
        "Room 9503": "5th floor classroom.",
        "Room 9504": "5th floor classroom.",
        "Room 9505": "5th floor classroom.",
        "Room 9506": "5th floor classroom.",
        "Room 9507": "5th floor classroom.",
        "Room 9508": "5th floor classroom.",
        "Room 9509": "Last room at the end of the 5th floor.",
      },
    },
  },
  "Technocore": {
    "bldgHint": "Research and innovation facility at the back of the campus.",
    "floors": {
      "1st Floor": {
        "No listed rooms": "Open innovation lobby and tech displays.",
      },
      "2nd Floor": {"No listed rooms": "Engineering research labs."},
      "3rd Floor": {"No listed rooms": "Advanced technology workspace."},
      "4th Floor": {"No listed rooms": "Collaboration floor."},
      "5th Floor": {"No listed rooms": "Top level labs and research areas."},
    },
  },
  "Other Areas": {
    "bldgHint": "Outdoor landmarks and sports facilities.",
    "floors": {
      "Ground": {
        "Entrance": "The main gate entrance at Aurora Blvd.",
        "PE Center 1": "First indoor court near Building 1.",
        "PE Center 2": "Second indoor court near Building 9.",
        "Innovation Hall": "Large hall near the Technocore entrance.",
        "Congregating Area": "Open space for student events.",
        "Garden": "The central open grass field.",
        "Anniversary Hall": "Located near the campus garden area.",
        "Parking Area": "The primary parking for students and staff.",
        "Study Hall": "The open-air study zone near the library.",
        "Seminar Room A&B": "Large administrative seminar hall.",
        "PE Hall 1": "Entrance hall of the first PE center.",
        "PE Hall 2": "Entrance hall of the second PE center.",
      },
    },
  },
};
