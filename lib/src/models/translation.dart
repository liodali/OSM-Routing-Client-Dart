const translation = '''
{
  "en": {
    "meta": {
        "capitalizeFirstLetter": true
    },
    "v5": {
        "constants": {
            "ordinalize": {
                "1": "1st",
                "2": "2nd",
                "3": "3rd",
                "4": "4th",
                "5": "5th",
                "6": "6th",
                "7": "7th",
                "8": "8th",
                "9": "9th",
                "10": "10th"
            },
            "direction": {
                "north": "north",
                "northeast": "northeast",
                "east": "east",
                "southeast": "southeast",
                "south": "south",
                "southwest": "southwest",
                "west": "west",
                "northwest": "northwest"
            },
            "modifier": {
                "left": "left",
                "right": "right",
                "sharp left": "sharp left",
                "sharp right": "sharp right",
                "slight left": "slight left",
                "slight right": "slight right",
                "straight": "straight",
                "uturn": "U-turn"
            },
            "lanes": {
                "xo": "Keep right",
                "ox": "Keep left",
                "xox": "Keep in the middle",
                "oxo": "Keep left or right"
            }
        },
        "modes": {
            "ferry": {
                "default": "Take the ferry",
                "name": "Take the ferry {way_name}",
                "destination": "Take the ferry towards {destination}"
            }
        },
        "phrase": {
            "two linked by distance": "{instruction_one}, then, in {distance}, {instruction_two}",
            "two linked": "{instruction_one}, then {instruction_two}",
            "one in distance": "In {distance}, {instruction_one}",
            "name and ref": "{name} ({ref})",
            "exit with number": "exit {exit}"
        },
        "arrive": {
            "default": {
                "default": "You have arrived at your {nth} destination",
                "upcoming": "You will arrive at your {nth} destination",
                "short": "You have arrived",
                "short-upcoming": "You will arrive",
                "named": "You have arrived at {waypoint_name}"
            },
            "left": {
                "default": "You have arrived at your {nth} destination, on the left",
                "upcoming": "You will arrive at your {nth} destination, on the left",
                "short": "You have arrived",
                "short-upcoming": "You will arrive",
                "named": "You have arrived at {waypoint_name}, on the left"
            },
            "right": {
                "default": "You have arrived at your {nth} destination, on the right",
                "upcoming": "You will arrive at your {nth} destination, on the right",
                "short": "You have arrived",
                "short-upcoming": "You will arrive",
                "named": "You have arrived at {waypoint_name}, on the right"
            },
            "sharp left": {
                "default": "You have arrived at your {nth} destination, on the left",
                "upcoming": "You will arrive at your {nth} destination, on the left",
                "short": "You have arrived",
                "short-upcoming": "You will arrive",
                "named": "You have arrived at {waypoint_name}, on the left"
            },
            "sharp right": {
                "default": "You have arrived at your {nth} destination, on the right",
                "upcoming": "You will arrive at your {nth} destination, on the right",
                "short": "You have arrived",
                "short-upcoming": "You will arrive",
                "named": "You have arrived at {waypoint_name}, on the right"
            },
            "slight right": {
                "default": "You have arrived at your {nth} destination, on the right",
                "upcoming": "You will arrive at your {nth} destination, on the right",
                "short": "You have arrived",
                "short-upcoming": "You will arrive",
                "named": "You have arrived at {waypoint_name}, on the right"
            },
            "slight left": {
                "default": "You have arrived at your {nth} destination, on the left",
                "upcoming": "You will arrive at your {nth} destination, on the left",
                "short": "You have arrived",
                "short-upcoming": "You will arrive",
                "named": "You have arrived at {waypoint_name}, on the left"
            },
            "straight": {
                "default": "You have arrived at your {nth} destination, straight ahead",
                "upcoming": "You will arrive at your {nth} destination, straight ahead",
                "short": "You have arrived",
                "short-upcoming": "You will arrive",
                "named": "You have arrived at {waypoint_name}, straight ahead"
            }
        },
        "continue": {
            "default": {
                "default": "Turn {modifier}",
                "name": "Turn {modifier} to stay on {way_name}",
                "destination": "Turn {modifier} towards {destination}",
                "exit": "Turn {modifier} onto {way_name}"
            },
            "straight": {
                "default": "Continue straight",
                "name": "Continue straight to stay on {way_name}",
                "destination": "Continue towards {destination}",
                "distance": "Continue straight for {distance}",
                "namedistance": "Continue on {way_name} for {distance}"
            },
            "sharp left": {
                "default": "Make a sharp left",
                "name": "Make a sharp left to stay on {way_name}",
                "destination": "Make a sharp left towards {destination}",
                "junction_name": "Make a sharp left at {junction_name}"
            },
            "sharp right": {
                "default": "Make a sharp right",
                "name": "Make a sharp right to stay on {way_name}",
                "destination": "Make a sharp right towards {destination}",
                "junction_name": "Make a sharp right at {junction_name}"
            },
            "slight left": {
                "default": "Make a slight left",
                "name": "Make a slight left to stay on {way_name}",
                "destination": "Make a slight left towards {destination}",
                "junction_name": "Make a slight left at {junction_name}"
            },
            "slight right": {
                "default": "Make a slight right",
                "name": "Make a slight right to stay on {way_name}",
                "destination": "Make a slight right towards {destination}",
                "junction_name": "Make a slight right at {junction_name}"
            },
            "uturn": {
                "default": "Make a U-turn",
                "name": "Make a U-turn and continue on {way_name}",
                "destination": "Make a U-turn towards {destination}",
                "junction_name": "Make a U-turn at {junction_name}"
            }
        },
        "depart": {
            "default": {
                "default": "Head {direction}",
                "name": "Head {direction} on {way_name}",
                "namedistance": "Head {direction} on {way_name} for {distance}"
            }
        },
        "end of road": {
            "default": {
                "default": "Turn {modifier}",
                "name": "Turn {modifier} onto {way_name}",
                "destination": "Turn {modifier} towards {destination}",
                "junction_name": "Turn {modifier} at {junction_name}"
            },
            "straight": {
                "default": "Continue straight",
                "name": "Continue straight onto {way_name}",
                "destination": "Continue straight towards {destination}",
                "junction_name": "Continue straight at {junction_name}"
            },
            "uturn": {
                "default": "Make a U-turn at the end of the road",
                "name": "Make a U-turn onto {way_name} at the end of the road",
                "destination": "Make a U-turn towards {destination} at the end of the road",
                "junction_name": "Make a U-turn at {junction_name}"
            }
        },
        "fork": {
            "default": {
                "default": "Keep {modifier} at the fork",
                "name": "Keep {modifier} onto {way_name}",
                "destination": "Keep {modifier} towards {destination}"
            },
            "slight left": {
                "default": "Keep left at the fork",
                "name": "Keep left onto {way_name}",
                "destination": "Keep left towards {destination}"
            },
            "slight right": {
                "default": "Keep right at the fork",
                "name": "Keep right onto {way_name}",
                "destination": "Keep right towards {destination}"
            },
            "sharp left": {
                "default": "Take a sharp left at the fork",
                "name": "Take a sharp left onto {way_name}",
                "destination": "Take a sharp left towards {destination}"
            },
            "sharp right": {
                "default": "Take a sharp right at the fork",
                "name": "Take a sharp right onto {way_name}",
                "destination": "Take a sharp right towards {destination}"
            },
            "uturn": {
                "default": "Make a U-turn",
                "name": "Make a U-turn onto {way_name}",
                "destination": "Make a U-turn towards {destination}"
            }
        },
        "merge": {
            "default": {
                "default": "Merge {modifier}",
                "name": "Merge {modifier} onto {way_name}",
                "destination": "Merge {modifier} towards {destination}"
            },
            "straight": {
                "default": "Merge",
                "name": "Merge onto {way_name}",
                "destination": "Merge towards {destination}"
            },
            "slight left": {
                "default": "Merge left",
                "name": "Merge left onto {way_name}",
                "destination": "Merge left towards {destination}"
            },
            "slight right": {
                "default": "Merge right",
                "name": "Merge right onto {way_name}",
                "destination": "Merge right towards {destination}"
            },
            "sharp left": {
                "default": "Merge left",
                "name": "Merge left onto {way_name}",
                "destination": "Merge left towards {destination}"
            },
            "sharp right": {
                "default": "Merge right",
                "name": "Merge right onto {way_name}",
                "destination": "Merge right towards {destination}"
            },
            "uturn": {
                "default": "Make a U-turn",
                "name": "Make a U-turn onto {way_name}",
                "destination": "Make a U-turn towards {destination}"
            }
        },
        "new name": {
            "default": {
                "default": "Continue {modifier}",
                "name": "Continue {modifier} onto {way_name}",
                "destination": "Continue {modifier} towards {destination}"
            },
            "straight": {
                "default": "Continue straight",
                "name": "Continue onto {way_name}",
                "destination": "Continue towards {destination}"
            },
            "sharp left": {
                "default": "Take a sharp left",
                "name": "Take a sharp left onto {way_name}",
                "destination": "Take a sharp left towards {destination}"
            },
            "sharp right": {
                "default": "Take a sharp right",
                "name": "Take a sharp right onto {way_name}",
                "destination": "Take a sharp right towards {destination}"
            },
            "slight left": {
                "default": "Continue slightly left",
                "name": "Continue slightly left onto {way_name}",
                "destination": "Continue slightly left towards {destination}"
            },
            "slight right": {
                "default": "Continue slightly right",
                "name": "Continue slightly right onto {way_name}",
                "destination": "Continue slightly right towards {destination}"
            },
            "uturn": {
                "default": "Make a U-turn",
                "name": "Make a U-turn onto {way_name}",
                "destination": "Make a U-turn towards {destination}"
            }
        },
        "notification": {
            "default": {
                "default": "Continue {modifier}",
                "name": "Continue {modifier} onto {way_name}",
                "destination": "Continue {modifier} towards {destination}"
            },
            "uturn": {
                "default": "Make a U-turn",
                "name": "Make a U-turn onto {way_name}",
                "destination": "Make a U-turn towards {destination}"
            }
        },
        "off ramp": {
            "default": {
                "default": "Take the ramp",
                "name": "Take the ramp onto {way_name}",
                "destination": "Take the ramp towards {destination}",
                "exit": "Take exit {exit}",
                "exit_destination": "Take exit {exit} towards {destination}"
            },
            "left": {
                "default": "Take the ramp on the left",
                "name": "Take the ramp on the left onto {way_name}",
                "destination": "Take the ramp on the left towards {destination}",
                "exit": "Take exit {exit} on the left",
                "exit_destination": "Take exit {exit} on the left towards {destination}"
            },
            "right": {
                "default": "Take the ramp on the right",
                "name": "Take the ramp on the right onto {way_name}",
                "destination": "Take the ramp on the right towards {destination}",
                "exit": "Take exit {exit} on the right",
                "exit_destination": "Take exit {exit} on the right towards {destination}"
            },
            "sharp left": {
                "default": "Take the ramp on the left",
                "name": "Take the ramp on the left onto {way_name}",
                "destination": "Take the ramp on the left towards {destination}",
                "exit": "Take exit {exit} on the left",
                "exit_destination": "Take exit {exit} on the left towards {destination}"
            },
            "sharp right": {
                "default": "Take the ramp on the right",
                "name": "Take the ramp on the right onto {way_name}",
                "destination": "Take the ramp on the right towards {destination}",
                "exit": "Take exit {exit} on the right",
                "exit_destination": "Take exit {exit} on the right towards {destination}"
            },
            "slight left": {
                "default": "Take the ramp on the left",
                "name": "Take the ramp on the left onto {way_name}",
                "destination": "Take the ramp on the left towards {destination}",
                "exit": "Take exit {exit} on the left",
                "exit_destination": "Take exit {exit} on the left towards {destination}"
            },
            "slight right": {
                "default": "Take the ramp on the right",
                "name": "Take the ramp on the right onto {way_name}",
                "destination": "Take the ramp on the right towards {destination}",
                "exit": "Take exit {exit} on the right",
                "exit_destination": "Take exit {exit} on the right towards {destination}"
            }
        },
        "on ramp": {
            "default": {
                "default": "Take the ramp",
                "name": "Take the ramp onto {way_name}",
                "destination": "Take the ramp towards {destination}"
            },
            "left": {
                "default": "Take the ramp on the left",
                "name": "Take the ramp on the left onto {way_name}",
                "destination": "Take the ramp on the left towards {destination}"
            },
            "right": {
                "default": "Take the ramp on the right",
                "name": "Take the ramp on the right onto {way_name}",
                "destination": "Take the ramp on the right towards {destination}"
            },
            "sharp left": {
                "default": "Take the ramp on the left",
                "name": "Take the ramp on the left onto {way_name}",
                "destination": "Take the ramp on the left towards {destination}"
            },
            "sharp right": {
                "default": "Take the ramp on the right",
                "name": "Take the ramp on the right onto {way_name}",
                "destination": "Take the ramp on the right towards {destination}"
            },
            "slight left": {
                "default": "Take the ramp on the left",
                "name": "Take the ramp on the left onto {way_name}",
                "destination": "Take the ramp on the left towards {destination}"
            },
            "slight right": {
                "default": "Take the ramp on the right",
                "name": "Take the ramp on the right onto {way_name}",
                "destination": "Take the ramp on the right towards {destination}"
            }
        },
        "rotary": {
            "default": {
                "default": {
                    "default": "Enter the roundabout",
                    "name": "Enter the roundabout and exit onto {way_name}",
                    "destination": "Enter the roundabout and exit towards {destination}"
                },
                "name": {
                    "default": "Enter {rotary_name}",
                    "name": "Enter {rotary_name} and exit onto {way_name}",
                    "destination": "Enter {rotary_name} and exit towards {destination}"
                },
                "exit": {
                    "default": "Enter the roundabout and take the {exit_number} exit",
                    "name": "Enter the roundabout and take the {exit_number} exit onto {way_name}",
                    "destination": "Enter the roundabout and take the {exit_number} exit towards {destination}"
                },
                "name_exit": {
                    "default": "Enter {rotary_name} and take the {exit_number} exit",
                    "name": "Enter {rotary_name} and take the {exit_number} exit onto {way_name}",
                    "destination": "Enter {rotary_name} and take the {exit_number} exit towards {destination}"
                }
            }
        },
        "roundabout": {
            "default": {
                "exit": {
                    "default": "Enter the roundabout and take the {exit_number} exit",
                    "name": "Enter the roundabout and take the {exit_number} exit onto {way_name}",
                    "destination": "Enter the roundabout and take the {exit_number} exit towards {destination}"
                },
                "default": {
                    "default": "Enter the roundabout",
                    "name": "Enter the roundabout and exit onto {way_name}",
                    "destination": "Enter the roundabout and exit towards {destination}"
                }
            }
        },
        "roundabout turn": {
            "default": {
                "default": "Make a {modifier}",
                "name": "Make a {modifier} onto {way_name}",
                "destination": "Make a {modifier} towards {destination}"
            },
            "left": {
                "default": "Turn left",
                "name": "Turn left onto {way_name}",
                "destination": "Turn left towards {destination}"
            },
            "right": {
                "default": "Turn right",
                "name": "Turn right onto {way_name}",
                "destination": "Turn right towards {destination}"
            },
            "straight": {
                "default": "Continue straight",
                "name": "Continue straight onto {way_name}",
                "destination": "Continue straight towards {destination}"
            }
        },
        "exit roundabout": {
            "default": {
                "default": "Exit the roundabout",
                "name": "Exit the roundabout onto {way_name}",
                "destination": "Exit the roundabout towards {destination}"
            }
        },
        "exit rotary": {
            "default": {
                "default": "Exit the roundabout",
                "name": "Exit the roundabout onto {way_name}",
                "destination": "Exit the roundabout towards {destination}"
            }
        },
        "turn": {
            "default": {
                "default": "Make a {modifier}",
                "name": "Make a {modifier} onto {way_name}",
                "destination": "Make a {modifier} towards {destination}",
                "junction_name": "Make a {modifier} at {junction_name}"
            },
            "left": {
                "default": "Turn left",
                "name": "Turn left onto {way_name}",
                "destination": "Turn left towards {destination}",
                "junction_name": "Turn left at {junction_name}"
            },
            "right": {
                "default": "Turn right",
                "name": "Turn right onto {way_name}",
                "destination": "Turn right towards {destination}",
                "junction_name": "Turn right at {junction_name}"
            },
            "straight": {
                "default": "Go straight",
                "name": "Go straight onto {way_name}",
                "destination": "Go straight towards {destination}",
                "junction_name": "Go straight at {junction_name}"
            }
        },
        "use lane": {
            "no_lanes": {
                "default": "Continue straight"
            },
            "default": {
                "default": "{lane_instruction}"
            }
        }
    }
},
"ar": {
    "meta": {
        "capitalizeFirstLetter": true
    },
    "v5": {
        "constants": {
            "ordinalize": {
                "1": "الأولى",
                "2": "الثانية",
                "3": "الثالثة",
                "4": "الرابعة",
                "5": "الخامسة",
                "6": "السادسة",
                "7": "السابعة",
                "8": "الثامنة",
                "9": "التاسعة",
                "10": "العاشرة"
            },
            "direction": {
                "north": "شمالاً",
                "northeast": "شمالاً شرقاً",
                "east": "شرقاً",
                "southeast": "جنوباً شرقاً",
                "south": "جنوباً",
                "southwest": "جنوباً غرباً",
                "west": "غرباً",
                "northwest": "شمالاً غرباً"
            },
            "modifier": {
                "left": "يسار",
                "right": "يمين",
                "sharp left": "يسار حاد",
                "sharp right": "يمين حاد",
                "slight left": "يساراً قليلاً",
                "slight right": "يساراً قليلاً",
                "straight": "مباشرة",
                "uturn": "الدوران للخلف"
            },
            "lanes": {
                "xo": "الزم اليمين",
                "ox": "الزم اليسار",
                "xox": "الزم الوسط",
                "oxo": "الزم اليمين أو اليسار"
            }
        },
        "modes": {
            "ferry": {
                "default": "اسلك العبّارة",
                "name": "اسلك العبّارة {way_name}",
                "destination": "اسلك العبّارة نحو {destination}"
            }
        },
        "phrase": {
            "two linked by distance": "{instruction_one}، وبعد {distance}، {instruction_two}",
            "two linked": "{instruction_one}، بعدها {instruction_two}",
            "one in distance": "بعد {distance}، {instruction_one}",
            "name and ref": "{name} ({ref})",
            "exit with number": "مخرج {exit}"
        },
        "arrive": {
            "default": {
                "default": "لقد وصلت إلى الوجهة {nth}",
                "upcoming": "ستصل إلى الوجهة {nth}",
                "short": "لقد وصلت",
                "short-upcoming": "ستصل",
                "named": "لقد وصلت إلى {waypoint_name}"
            },
            "left": {
                "default": "لقد وصلت إلى الوجهة {nth}، على يسارك",
                "upcoming": "ستصل إلى الوجهة {nth}، على يسارك",
                "short": "لقد وصلت",
                "short-upcoming": "ستصل",
                "named": "لقد وصلت إلى {waypoint_name}، على يسارك"
            },
            "right": {
                "default": "لقد وصلت إلى الوجهة {nth}، على يمينك",
                "upcoming": "ستصل إلى الوجهة {nth}، على يمينك",
                "short": "لقد وصلت",
                "short-upcoming": "ستصل",
                "named": "لقد وصلت إلى {waypoint_name}، على يمينك"
            },
            "sharp left": {
                "default": "لقد وصلت إلى الوجهة {nth}، على يسارك",
                "upcoming": "ستصل إلى الوجهة {nth}، على يسارك",
                "short": "لقد وصلت",
                "short-upcoming": "ستصل",
                "named": "لقد وصلت إلى {waypoint_name}، على يسارك"
            },
            "sharp right": {
                "default": "لقد وصلت إلى الوجهة {nth}، على يمينك",
                "upcoming": "ستصل إلى الوجهة {nth}، على يمينك",
                "short": "لقد وصلت",
                "short-upcoming": "ستصل",
                "named": "لقد وصلت إلى {waypoint_name}، على يمينك"
            },
            "slight right": {
                "default": "لقد وصلت إلى الوجهة {nth}، على يمينك",
                "upcoming": "ستصل إلى الوجهة {nth}، على يمينك",
                "short": "لقد وصلت",
                "short-upcoming": "ستصل",
                "named": "لقد وصلت إلى {waypoint_name}، على يمينك"
            },
            "slight left": {
                "default": "لقد وصلت إلى الوجهة {nth}، على يسارك",
                "upcoming": "ستصل إلى الوجهة {nth}، على يسارك",
                "short": "لقد وصلت",
                "short-upcoming": "ستصل",
                "named": "لقد وصلت إلى {waypoint_name}، على يسارك"
            },
            "straight": {
                "default": "لقد وصلت إلى الوجهة {nth}، مباشرة أمامك",
                "upcoming": "ستصل إلى الوجهة {nth}، مباشرة أمامك",
                "short": "لقد وصلت",
                "short-upcoming": "ستصل",
                "named": "لقد وصلت إلى {waypoint_name}، إلى الأمام مباشرة"
            }
        },
        "continue": {
            "default": {
                "default": "انعطف {modifier}ا",
                "name": "انعطف {modifier}ا لتبقى على {way_name}",
                "destination": "انعطف {modifier}ا نحو {destination}",
                "exit": "انعطف {modifier}ا على {way_name}"
            },
            "straight": {
                "default": "تابع قدما",
                "name": "تابع قدما لتبقى على {way_name}",
                "destination": "تابع نحو {destination}",
                "distance": "تابع قدما لمسافة {distance}",
                "namedistance": "تابع على {way_name} لمسافة {distance}"
            },
            "sharp left": {
                "default": "انعطف يساراً حاداً",
                "name": "انعطف يساراً حاداً لتبقى على {way_name}",
                "destination": "انعطف يساراً حاداً نحو {destination}",
                "junction_name": "انعطف يساراً حاداً لتبقى على {junction_name}"
            },
            "sharp right": {
                "default": "انعطف يمينا حاداً ",
                "name": "انعطف يميناً حاداً لتبقى على {way_name}",
                "destination": "انعطف يميناً حاداً نحو {destination}",
                "junction_name": "انعطف يميناً حاداً لتبقى على {junction_name}"
            },
            "slight left": {
                "default": "انعطف يساراً قليلاً",
                "name": "انعطف يساراً قليلاً لتبقى على {way_name}",
                "destination": "انعطف يساراً قليلاً نحو {destination}",
                "junction_name": "انعطف يساراً قليلاً لتبقى على {junction_name}"
            },
            "slight right": {
                "default": "انعطف يميناً قليلاً",
                "name": "انعطف يميناً قليلاً لتبقى على {way_name}",
                "destination": "انعطف يميناً قليلاً نحو {destination}",
                "junction_name": "انعطف يميناً قليلاً نحو {junction_name}"
            },
            "uturn": {
                "default": "انعطف دوراناً عكسياً",
                "name": "انعطف دوراناً عكسياً  وتابع نحو {way_name}",
                "destination": "انعطف دوراناً عكسياً نحو {destination}",
                "junction_name": "انعطف دوراناً عكسياً  وتابع نحو {junction_name}"
            }
        },
        "depart": {
            "default": {
                "default": "توجّه {direction}",
                "name": "توجّه {direction} نحو {way_name}",
                "namedistance": "توجّه {direction} نحو {way_name} لمسافة {distance}"
            }
        },
        "end of road": {
            "default": {
                "default": "انعطف {modifier}ا",
                "name": "انعطف {modifier}ا على {way_name}",
                "destination": "انعطف {modifier}ا نحو {destination}",
                "junction_name": "انعطف {modifier}ا على {junction_name}"
            },
            "straight": {
                "default": "تابع قدماً",
                "name": "تابع إلى الأمام على {way_name}",
                "destination": "تابع قدماً نحو {destination}",
                "junction_name": "تابع إلى الأمام على {junction_name}"
            },
            "uturn": {
                "default": "انعطف دوراناً عكسياً عند نهاية الطريق",
                "name": "انعطف دوراناً عكسياً على {way_name} عند نهاية الطريق",
                "destination": "انعطف دوراناً عكسياً نحو {destination} عند نهاية الطريق",
                "junction_name": "انعطف دوراناً عكسياً نحو {junction_name}"
            }
        },
        "fork": {
            "default": {
                "default": " توجّه {modifier}",
                "name": "الزم {modifier} على {way_name}",
                "destination": "توجّه نحو {modifier} لمسافة {distance} "
            },
            "slight left": {
                "default": "انعطف يساراً قليلاً",
                "name": "انعطف يساراً قليلاً لتبقى على {way_name}",
                "destination": "انعطف يساراً قليلاً نحو {destination}"
            },
            "slight right": {
                "default": "انعطف يميناً قليلاً",
                "name": "انعطف يميناً قليلاً لتبقى على {way_name}",
                "destination": "انعطف يميناً قليلاً نحو {destination}"
            },
            "sharp left": {
                "default": "انعطف يساراً حاداً",
                "name": "انعطف يساراً حاداً لتبقى على {way_name}",
                "destination": "انعطف يساراً حاداً نحو {destination}"
            },
            "sharp right": {
                "default": "انعطف يميناً حاداً",
                "name": " انعطف يميناً حاداً لتبقى على {way_name}",
                "destination": "انعطف يميناً حاداً نحو {destination} "
            },
            "uturn": {
                "default": "انعطف دوراناً عكسياً",
                "name": "انعطف دوراناً عكسياً على {way_name}",
                "destination": "انعطف دوراناً عكسياً نحو {destination}"
            }
        },
        "merge": {
            "default": {
                "default": "انعطف {modifier}",
                "name": "انعطف {modifier} على {way_name}",
                "destination": "انعطف {modifier} باتجاه {destination}"
            },
            "straight": {
                "default": "تابع قدماً",
                "name": "تابع قدماً على {way_name}",
                "destination": "تابع قدماً نحو {destination}"
            },
            "slight left": {
                "default": "انعطف يساراً قليلاً",
                "name": "انعطف يساراً قليلاً لتبقى على {way_name}",
                "destination": "انعطف يساراً قليلاً نحو {destination} "
            },
            "slight right": {
                "default": "انعطف يميناً قليلاً",
                "name": "انعطف يميناً قليلاً لتبقى على {way_name}",
                "destination": "انعطف يمينا قليلا نحو {destination}"
            },
            "sharp left": {
                "default": "انعطف يسارا حادا",
                "name": "انعطف يسارا حادا لتبقى على {way_name}",
                "destination": "انعطف يسارا حادا نحو {destination}"
            },
            "sharp right": {
                "default": "انعطف يمينا حادا",
                "name": "انعطف يمينا حادا لتبقى على {way_name}",
                "destination": "انعطف يمينا حادا نحو {destination}"
            },
            "uturn": {
                "default": "انعطف دورانا عكسيا",
                "name": "انعطف دورانا عكسيا على {way_name}",
                "destination": "انعطف دورانا عكسيا نحو {destination}"
            }
        },
        "new name": {
            "default": {
                "default": "تابع {modifier}ا",
                "name": "تابع {modifier}ا على {way_name}",
                "destination": "تابع {modifier} نحو {destination}"
            },
            "straight": {
                "default": "تابع قدما",
                "name": "تابع على {way_name}",
                "destination": "تابع نحو {destination}"
            },
            "sharp left": {
                "default": "تابع يسارا باتجاه حاد",
                "name": "انعطف يسارا حادا لتبقى على {way_name}",
                "destination": "تابع يسارا باتجاه حاد نحو {destination}"
            },
            "sharp right": {
                "default": "تابع يمينا باتجاه حاد",
                "name": " انعطف يمينا حادا لتبقى على {way_name}",
                "destination": "تابع يمينا باتجاه حاد نحو {destination}"
            },
            "slight left": {
                "default": "تابع يساراً قليلاً",
                "name": "تابع يساراً قليلاً على {way_name}",
                "destination": "تابع يسارا باتجاه قليلا نحو {destination}"
            },
            "slight right": {
                "default": "تابع يميناً قليلاً",
                "name": "تابع يميناً قليلاً على {way_name}",
                "destination": "تابع يمينا باتجاه قليلا نحو {destination}"
            },
            "uturn": {
                "default": "انعطف دورانا عكسيا",
                "name": "انعطف دورانا عكسيا على {way_name}",
                "destination": "انعطف دورانا عكسيا نحو {destination}"
            }
        },
        "notification": {
            "default": {
                "default": "تابع {modifier}ا",
                "name": "تابع {modifier}ا على {way_name}",
                "destination": "تابع {modifier} نحو {destination} "
            },
            "uturn": {
                "default": "انعطف دورانا عكسيا",
                "name": "انعطف دورانا عكسيا على {way_name}",
                "destination": "انعطف دورانا عكسيا نحو {destination}"
            }
        },
        "off ramp": {
            "default": {
                "default": "اسلك المنحدر",
                "name": "اتبع المنحدر على {way_name}",
                "destination": "اتبع المنحدر باتجاه {destination}",
                "exit": "اسلك المخرج {exit}",
                "exit_destination": "اسلك المخرج {exit} نحو {destination}"
            },
            "left": {
                "default": "اسلك المخرج يسارا",
                "name": "اسلك المدخل يسارا حادا لتبقى على {way_name}",
                "destination": "اسلك المدخل يسارا قليلا نحو {destination}",
                "exit": "اسلك المخرج {exit} يسارا",
                "exit_destination": "اسلك المخرج {exit} يسارا نحو {destination}"
            },
            "right": {
                "default": "اسلك المسار يمينا",
                "name": "اسلك المدخل يمينا لتبقى على {way_name}",
                "destination": "اسلك المدخل يمينا قليلا نحو {destination}",
                "exit": "اسلك المخرج يمينا {exit}",
                "exit_destination": "اسلك المخرج {exit} يمينا نحو {destination} "
            },
            "sharp left": {
                "default": "اسلك المسار يسارا حادا",
                "name": "اسلك المدخل يسارا حادا لتبقى على {way_name}",
                "destination": "اسلك المدخل يسارا قليلا نحو {destination}",
                "exit": "اسلك المخرج{exit} الحاد يسارا",
                "exit_destination": "اسلك المخرج {exit} الحاد يسارا نحو {destination}"
            },
            "sharp right": {
                "default": "اسلك المسار يمينا حادا",
                "name": "اسلك المدخل يمينا لتبقى على {way_name}",
                "destination": "اسلك المدخل يمينا قليلا نحو {destination}",
                "exit": "اسلك المخرج {exit} الحاد يمينا",
                "exit_destination": "اسلك المخرج {exit} الحاد يمينا نحو {destination} "
            },
            "slight left": {
                "default": "اسلك المسار يسارا قليلا",
                "name": "اسلك المدخل يسارا حادا لتبقى على {way_name}",
                "destination": "اسلك المدخل يسارا قليلا نحو {destination}",
                "exit": "اسلك المخرج {exit} يسارا قليلا",
                "exit_destination": "اسلك المخرج {exit} يسارا قليلا نحو {destination} "
            },
            "slight right": {
                "default": "اسلك المسار يمينا قليلا",
                "name": "اسلك المدخل يمينا لتبقى على {way_name}",
                "destination": "اسلك المدخل يمينا قليلا نحو {destination}",
                "exit": "اسلك المخرج {exit} يمينا قليلا",
                "exit_destination": "اسلك المخرج {exit} يمينا قليلا نحو {destination} "
            }
        },
        "on ramp": {
            "default": {
                "default": "اسلك المدخل {modifier}",
                "name": "اتبع المنحدر على {way_name}",
                "destination": "اتبع المنحدر باتجاه {destination}"
            },
            "left": {
                "default": "اسلك المدخل يسارا",
                "name": "اسلك المدخل يسارا لتبقى على {way_name}",
                "destination": "اسلك المدخل يسارا نحو {destination} "
            },
            "right": {
                "default": "اسلك المدخل يمينا",
                "name": "اسلك المدخل يمينا لتبقى على {way_name}",
                "destination": "اسلك المدخل يمينا نحو {destination}"
            },
            "sharp left": {
                "default": "اسلك المدخل يسارا حادا",
                "name": "اسلك المدخل يسارا حادا لتبقى على {way_name}",
                "destination": "اسلك المدخل يسارا حادا نحو {destination}"
            },
            "sharp right": {
                "default": "اسلك المدخل يمينا حادا",
                "name": "اسلك المدخل يمينا حادا لتبقى على {way_name}",
                "destination": "اسلك المدخل يمينا حادا نحو {destination}"
            },
            "slight left": {
                "default": "اسلك المدخل يسارا قليلا",
                "name": "اسلك المدخل يسارا قليلا لتبقى على {way_name}",
                "destination": "اسلك المدخل يسارا قليلا نحو {destination}"
            },
            "slight right": {
                "default": "اسلك المدخل يمينا قليلا",
                "name": "اسلك المدخل يمينا قليلا لتبقى على {way_name}",
                "destination": "اسلك المدخل يمينا قليلا نحو {destination}"
            }
        },
        "rotary": {
            "default": {
                "default": {
                    "default": "اسلك مسار الدوران",
                    "name": "اسلك مسار الدوران واخرج على {way_name}",
                    "destination": "اسلك مسار الدوران واخرج باتجاه {destination}"
                },
                "name": {
                    "default": "ادخل {rotary_name}",
                    "name": "اسلك {rotary_name} واخرج على {way_name}",
                    "destination": "اسلك {rotary_name} واخرج باتجاه {destination}"
                },
                "exit": {
                    "default": "اسلك مسار الدوران واتّبع المخرج {exit_number}",
                    "name": "اسلك مسار الدوران واتبع المخرج {exit_number} على {way_name}",
                    "destination": "اسلك مسار الدوران واتبع المخرج {exit_number} باتجاه {destination}"
                },
                "name_exit": {
                    "default": "اسلك {rotary_name} واتبع المخرج {exit_number}",
                    "name": "ادخل {rotary_name} واسلك المخرج {exit_number} على {way_name}",
                    "destination": "ادخل {rotary_name} واسلك المخرج {exit_number} باتجاه {destination}"
                }
            }
        },
        "roundabout": {
            "default": {
                "exit": {
                    "default": "ادخل مسار الدوران واسلك المخرج {exit_number}",
                    "name": "اسلك مسار الدوران واتبع المخرج {exit_number} على {way_name}",
                    "destination": "ادخل مسار الدوران واسلك المخرج {exit_number} باتجاه {destination}"
                },
                "default": {
                    "default": "اسلك مسار الدوران",
                    "name": "اسلك مسار الدوران واخرج على {way_name}",
                    "destination": "اسلك مسار الدوران واخرج باتجاه {destination}"
                }
            }
        },
        "roundabout turn": {
            "default": {
                "default": " اسلك مسار الدخول الى الدوران",
                "name": "انعطف {modifier} على {way_name}",
                "destination": "انعطف {modifier} نحو {destination}"
            },
            "left": {
                "default": "اسلك مسار الدوران يسارا",
                "name": "اسلك مسار الدوران يسارا على {way_name}",
                "destination": "انعطف يسارا نحو {destination}"
            },
            "right": {
                "default": "اسلك مسار الدوران يمينا",
                "name": "اسلك مسار الدوران يمينا على {way_name}",
                "destination": "انعطف يمينا نحو {destination}"
            },
            "straight": {
                "default": "تابع قدما",
                "name": "تابع إلى الأمام على {way_name}",
                "destination": "تابع قدما نحو {destination}"
            }
        },
        "exit roundabout": {
            "default": {
                "default": "اخرج من مسار الدوران",
                "name": "اخرج من مسار الدوران على {way_name}",
                "destination": "اسلك مسار الخروج {destination}"
            }
        },
        "exit rotary": {
            "default": {
                "default": "اخرج من الدوّار",
                "name": "اخرج من مسار الدوران على {way_name}",
                "destination": "اسلك مسار الخروج {destination}"
            }
        },
        "turn": {
            "default": {
                "default": "انعطف نحو {modifier}",
                "name": "انعطف {modifier} على {way_name}",
                "destination": "انعطف {modifier} نحو {destination}",
                "junction_name": "انعطف {modifier} على {junction_name}"
            },
            "left": {
                "default": "انعطف يسارا",
                "name": "اسلك مسار الدوران يسارا على {way_name}",
                "destination": "انعطف يسارا نحو {destination}",
                "junction_name": "اسلك مسار الدوران يسارا على {junction_name}"
            },
            "right": {
                "default": "انعطف يمينا",
                "name": "اسلك مسار الدوران يمينا على {way_name}",
                "destination": "انعطف يمينا نحو {destination}",
                "junction_name": "اسلك مسار الدوران يمينا على {junction_name}"
            },
            "straight": {
                "default": "انطلق قدما",
                "name": "انطلق قدما على {way_name}",
                "destination": "انطلق قدما نحو {destination}",
                "junction_name": "انطلق قدما على {junction_name}"
            }
        },
        "use lane": {
            "no_lanes": {
                "default": "تابع قدما"
            },
            "default": {
                "default": "{lane_instruction}"
            }
        }
    }
},
"de": {
    "meta": {
        "capitalizeFirstLetter": true
    },
    "v5": {
        "constants": {
            "ordinalize": {
                "1": "erste",
                "2": "zweite",
                "3": "dritte",
                "4": "vierte",
                "5": "fünfte",
                "6": "sechste",
                "7": "siebente",
                "8": "achte",
                "9": "neunte",
                "10": "zehnte"
            },
            "direction": {
                "north": "Norden",
                "northeast": "Nordosten",
                "east": "Osten",
                "southeast": "Südosten",
                "south": "Süden",
                "southwest": "Südwesten",
                "west": "Westen",
                "northwest": "Nordwesten"
            },
            "modifier": {
                "left": "links",
                "right": "rechts",
                "sharp left": "scharf links",
                "sharp right": "scharf rechts",
                "slight left": "leicht links",
                "slight right": "leicht rechts",
                "straight": "geradeaus",
                "uturn": "180°-Wendung"
            },
            "lanes": {
                "xo": "Rechts halten",
                "ox": "Links halten",
                "xox": "Mittlere Spur nutzen",
                "oxo": "Rechts oder links halten"
            }
        },
        "modes": {
            "ferry": {
                "default": "Fähre nehmen",
                "name": "Fähre nehmen {way_name}",
                "destination": "Fähre nehmen Richtung {destination}"
            }
        },
        "phrase": {
            "two linked by distance": "{instruction_one} danach in {distance} {instruction_two}",
            "two linked": "{instruction_one} danach {instruction_two}",
            "one in distance": "In {distance}, {instruction_one}",
            "name and ref": "{name} ({ref})",
            "exit with number": "exit {exit}"
        },
        "arrive": {
            "default": {
                "default": "Sie haben Ihr {nth} Ziel erreicht",
                "upcoming": "Sie haben Ihr {nth} Ziel erreicht",
                "short": "Sie haben Ihr {nth} Ziel erreicht",
                "short-upcoming": "Sie haben Ihr {nth} Ziel erreicht",
                "named": "Sie haben Ihr {waypoint_name}"
            },
            "left": {
                "default": "Sie haben Ihr {nth} Ziel erreicht, es befindet sich links",
                "upcoming": "Sie haben Ihr {nth} Ziel erreicht, es befindet sich links",
                "short": "Sie haben Ihr {nth} Ziel erreicht",
                "short-upcoming": "Sie haben Ihr {nth} Ziel erreicht",
                "named": "Sie haben Ihr {waypoint_name}, es befindet sich links"
            },
            "right": {
                "default": "Sie haben Ihr {nth} Ziel erreicht, es befindet sich rechts",
                "upcoming": "Sie haben Ihr {nth} Ziel erreicht, es befindet sich rechts",
                "short": "Sie haben Ihr {nth} Ziel erreicht",
                "short-upcoming": "Sie haben Ihr {nth} Ziel erreicht",
                "named": "Sie haben Ihr {waypoint_name}, es befindet sich rechts"
            },
            "sharp left": {
                "default": "Sie haben Ihr {nth} Ziel erreicht, es befindet sich links",
                "upcoming": "Sie haben Ihr {nth} Ziel erreicht, es befindet sich links",
                "short": "Sie haben Ihr {nth} Ziel erreicht",
                "short-upcoming": "Sie haben Ihr {nth} Ziel erreicht",
                "named": "Sie haben Ihr {waypoint_name}, es befindet sich links"
            },
            "sharp right": {
                "default": "Sie haben Ihr {nth} Ziel erreicht, es befindet sich rechts",
                "upcoming": "Sie haben Ihr {nth} Ziel erreicht, es befindet sich rechts",
                "short": "Sie haben Ihr {nth} Ziel erreicht",
                "short-upcoming": "Sie haben Ihr {nth} Ziel erreicht",
                "named": "Sie haben Ihr {waypoint_name}, es befindet sich rechts"
            },
            "slight right": {
                "default": "Sie haben Ihr {nth} Ziel erreicht, es befindet sich rechts",
                "upcoming": "Sie haben Ihr {nth} Ziel erreicht, es befindet sich rechts",
                "short": "Sie haben Ihr {nth} Ziel erreicht",
                "short-upcoming": "Sie haben Ihr {nth} Ziel erreicht",
                "named": "Sie haben Ihr {waypoint_name}, es befindet sich rechts"
            },
            "slight left": {
                "default": "Sie haben Ihr {nth} Ziel erreicht, es befindet sich links",
                "upcoming": "Sie haben Ihr {nth} Ziel erreicht, es befindet sich links",
                "short": "Sie haben Ihr {nth} Ziel erreicht",
                "short-upcoming": "Sie haben Ihr {nth} Ziel erreicht",
                "named": "Sie haben Ihr {waypoint_name}, es befindet sich links"
            },
            "straight": {
                "default": "Sie haben Ihr {nth} Ziel erreicht, es befindet sich geradeaus",
                "upcoming": "Sie haben Ihr {nth} Ziel erreicht, es befindet sich geradeaus",
                "short": "Sie haben Ihr {nth} Ziel erreicht",
                "short-upcoming": "Sie haben Ihr {nth} Ziel erreicht",
                "named": "Sie haben Ihr {waypoint_name}, es befindet sich geradeaus"
            }
        },
        "continue": {
            "default": {
                "default": "{modifier} abbiegen",
                "name": "{modifier} weiterfahren auf {way_name}",
                "destination": "{modifier} abbiegen Richtung {destination}",
                "exit": "{modifier} abbiegen auf {way_name}"
            },
            "straight": {
                "default": "Geradeaus weiterfahren",
                "name": "Geradeaus weiterfahren auf {way_name}",
                "destination": "Weiterfahren in Richtung {destination}",
                "distance": "Geradeaus weiterfahren für {distance}",
                "namedistance": "Geradeaus weiterfahren auf {way_name} für {distance}"
            },
            "sharp left": {
                "default": "Scharf links",
                "name": "Scharf links weiterfahren auf {way_name}",
                "destination": "Scharf links Richtung {destination}",
                "junction_name": "Scharf links weiterfahren an {junction_name}"
            },
            "sharp right": {
                "default": "Scharf rechts",
                "name": "Scharf rechts weiterfahren auf {way_name}",
                "destination": "Scharf rechts Richtung {destination}",
                "junction_name": "Scharf rechts weiterfahren an {junction_name}"
            },
            "slight left": {
                "default": "Leicht links",
                "name": "Leicht links weiter auf {way_name}",
                "destination": "Leicht links weiter Richtung {destination}",
                "junction_name": "Leicht links weiter an {junction_name}"
            },
            "slight right": {
                "default": "Leicht rechts weiter",
                "name": "Leicht rechts weiter auf {way_name}",
                "destination": "Leicht rechts weiter Richtung {destination}",
                "junction_name": "Leicht rechts weiter an {junction_name}"
            },
            "uturn": {
                "default": "180°-Wendung",
                "name": "180°-Wendung auf {way_name}",
                "destination": "180°-Wendung Richtung {destination}",
                "junction_name": "180°-Wendung an {junction_name}"
            }
        },
        "depart": {
            "default": {
                "default": "Fahren Sie Richtung {direction}",
                "name": "Fahren Sie Richtung {direction} auf {way_name}",
                "namedistance": "Fahren Sie Richtung {direction} auf {way_name} für {distance}"
            }
        },
        "end of road": {
            "default": {
                "default": "{modifier} abbiegen",
                "name": "{modifier} abbiegen auf {way_name}",
                "destination": "{modifier} abbiegen Richtung {destination}",
                "junction_name": "{modifier} abbiegen an {junction_name}"
            },
            "straight": {
                "default": "Geradeaus weiterfahren",
                "name": "Geradeaus weiterfahren auf {way_name}",
                "destination": "Geradeaus weiterfahren Richtung {destination}",
                "junction_name": "Geradeaus weiterfahren an {junction_name}"
            },
            "uturn": {
                "default": "180°-Wendung am Ende der Straße",
                "name": "180°-Wendung auf {way_name} am Ende der Straße",
                "destination": "180°-Wendung Richtung {destination} am Ende der Straße",
                "junction_name": "180°-Wendung an {junction_name}"
            }
        },
        "fork": {
            "default": {
                "default": "{modifier} halten an der Gabelung",
                "name": "{modifier} halten an der Gabelung auf {way_name}",
                "destination": "{modifier} halten an der Gabelung Richtung {destination}"
            },
            "slight left": {
                "default": "Links halten an der Gabelung",
                "name": "Links halten an der Gabelung auf {way_name}",
                "destination": "Links halten an der Gabelung Richtung {destination}"
            },
            "slight right": {
                "default": "Rechts halten an der Gabelung",
                "name": "Rechts halten an der Gabelung auf {way_name}",
                "destination": "Rechts halten an der Gabelung Richtung {destination}"
            },
            "sharp left": {
                "default": "Scharf links abbiegen an der Gabelung",
                "name": "Scharf links auf {way_name}",
                "destination": "Scharf links Richtung {destination}"
            },
            "sharp right": {
                "default": "Scharf rechts abbiegen an der Gabelung",
                "name": "Scharf rechts auf {way_name}",
                "destination": "Scharf rechts Richtung {destination}"
            },
            "uturn": {
                "default": "180°-Wendung",
                "name": "180°-Wendung auf {way_name}",
                "destination": "180°-Wendung Richtung {destination}"
            }
        },
        "merge": {
            "default": {
                "default": "{modifier} auffahren",
                "name": "{modifier} auffahren auf {way_name}",
                "destination": "{modifier} auffahren Richtung {destination}"
            },
            "straight": {
                "default": "geradeaus auffahren",
                "name": "geradeaus auffahren auf {way_name}",
                "destination": "geradeaus auffahren Richtung {destination}"
            },
            "slight left": {
                "default": "Leicht links auffahren",
                "name": "Leicht links auffahren auf {way_name}",
                "destination": "Leicht links auffahren Richtung {destination}"
            },
            "slight right": {
                "default": "Leicht rechts auffahren",
                "name": "Leicht rechts auffahren auf {way_name}",
                "destination": "Leicht rechts auffahren Richtung {destination}"
            },
            "sharp left": {
                "default": "Scharf links auffahren",
                "name": "Scharf links auffahren auf {way_name}",
                "destination": "Scharf links auffahren Richtung {destination}"
            },
            "sharp right": {
                "default": "Scharf rechts auffahren",
                "name": "Scharf rechts auffahren auf {way_name}",
                "destination": "Scharf rechts auffahren Richtung {destination}"
            },
            "uturn": {
                "default": "180°-Wendung",
                "name": "180°-Wendung auf {way_name}",
                "destination": "180°-Wendung Richtung {destination}"
            }
        },
        "new name": {
            "default": {
                "default": "{modifier} weiterfahren",
                "name": "{modifier} weiterfahren auf {way_name}",
                "destination": "{modifier} weiterfahren Richtung {destination}"
            },
            "straight": {
                "default": "Geradeaus weiterfahren",
                "name": "Weiterfahren auf {way_name}",
                "destination": "Weiterfahren in Richtung {destination}"
            },
            "sharp left": {
                "default": "Scharf links",
                "name": "Scharf links auf {way_name}",
                "destination": "Scharf links Richtung {destination}"
            },
            "sharp right": {
                "default": "Scharf rechts",
                "name": "Scharf rechts auf {way_name}",
                "destination": "Scharf rechts Richtung {destination}"
            },
            "slight left": {
                "default": "Leicht links weiter",
                "name": "Leicht links weiter auf {way_name}",
                "destination": "Leicht links weiter Richtung {destination}"
            },
            "slight right": {
                "default": "Leicht rechts weiter",
                "name": "Leicht rechts weiter auf {way_name}",
                "destination": "Leicht rechts weiter Richtung {destination}"
            },
            "uturn": {
                "default": "180°-Wendung",
                "name": "180°-Wendung auf {way_name}",
                "destination": "180°-Wendung Richtung {destination}"
            }
        },
        "notification": {
            "default": {
                "default": "{modifier} weiterfahren",
                "name": "{modifier} weiterfahren auf {way_name}",
                "destination": "{modifier} weiterfahren Richtung {destination}"
            },
            "uturn": {
                "default": "180°-Wendung",
                "name": "180°-Wendung auf {way_name}",
                "destination": "180°-Wendung Richtung {destination}"
            }
        },
        "off ramp": {
            "default": {
                "default": "Ausfahrt nehmen",
                "name": "Ausfahrt nehmen auf {way_name}",
                "destination": "Ausfahrt nehmen Richtung {destination}",
                "exit": "Ausfahrt {exit} nehmen",
                "exit_destination": "Ausfahrt {exit} nehmen Richtung {destination}"
            },
            "left": {
                "default": "Ausfahrt links nehmen",
                "name": "Ausfahrt links nehmen auf {way_name}",
                "destination": "Ausfahrt links nehmen Richtung {destination}",
                "exit": "Ausfahrt {exit} links nehmen",
                "exit_destination": "Ausfahrt {exit} links nehmen Richtung {destination}"
            },
            "right": {
                "default": "Ausfahrt rechts nehmen",
                "name": "Ausfahrt rechts nehmen Richtung {way_name}",
                "destination": "Ausfahrt rechts nehmen Richtung {destination}",
                "exit": "Ausfahrt {exit} rechts nehmen",
                "exit_destination": "Ausfahrt {exit} nehmen Richtung {destination}"
            },
            "sharp left": {
                "default": "Ausfahrt links nehmen",
                "name": "Ausfahrt links Seite nehmen auf {way_name}",
                "destination": "Ausfahrt links nehmen Richtung {destination}",
                "exit": "Ausfahrt {exit} links nehmen",
                "exit_destination": "Ausfahrt{exit} links nehmen Richtung {destination}"
            },
            "sharp right": {
                "default": "Ausfahrt rechts nehmen",
                "name": "Ausfahrt rechts nehmen auf {way_name}",
                "destination": "Ausfahrt rechts nehmen Richtung {destination}",
                "exit": "Ausfahrt {exit} rechts nehmen",
                "exit_destination": "Ausfahrt {exit} nehmen Richtung {destination}"
            },
            "slight left": {
                "default": "Ausfahrt links nehmen",
                "name": "Ausfahrt links nehmen auf {way_name}",
                "destination": "Ausfahrt links nehmen Richtung {destination}",
                "exit": "Ausfahrt {exit} nehmen",
                "exit_destination": "Ausfahrt {exit} links nehmen Richtung {destination}"
            },
            "slight right": {
                "default": "Ausfahrt rechts nehmen",
                "name": "Ausfahrt rechts nehmen auf {way_name}",
                "destination": "Ausfahrt rechts nehmen Richtung {destination}",
                "exit": "Ausfahrt {exit} rechts nehmen",
                "exit_destination": "Ausfahrt {exit} nehmen Richtung {destination}"
            }
        },
        "on ramp": {
            "default": {
                "default": "Auffahrt nehmen",
                "name": "Auffahrt nehmen auf {way_name}",
                "destination": "Auffahrt nehmen Richtung {destination}"
            },
            "left": {
                "default": "Auffahrt links nehmen",
                "name": "Auffahrt links nehmen auf {way_name}",
                "destination": "Auffahrt links nehmen Richtung {destination}"
            },
            "right": {
                "default": "Auffahrt rechts nehmen",
                "name": "Auffahrt rechts nehmen auf {way_name}",
                "destination": "Auffahrt rechts nehmen Richtung {destination}"
            },
            "sharp left": {
                "default": "Auffahrt links nehmen",
                "name": "Auffahrt links nehmen auf {way_name}",
                "destination": "Auffahrt links nehmen Richtung {destination}"
            },
            "sharp right": {
                "default": "Auffahrt rechts nehmen",
                "name": "Auffahrt rechts nehmen auf {way_name}",
                "destination": "Auffahrt rechts nehmen Richtung {destination}"
            },
            "slight left": {
                "default": "Auffahrt links Seite nehmen",
                "name": "Auffahrt links nehmen auf {way_name}",
                "destination": "Auffahrt links nehmen Richtung {destination}"
            },
            "slight right": {
                "default": "Auffahrt rechts nehmen",
                "name": "Auffahrt rechts nehmen auf {way_name}",
                "destination": "Auffahrt rechts nehmen Richtung {destination}"
            }
        },
        "rotary": {
            "default": {
                "default": {
                    "default": "In den Kreisverkehr fahren",
                    "name": "Im Kreisverkehr die Ausfahrt auf {way_name} nehmen",
                    "destination": "Im Kreisverkehr die Ausfahrt Richtung {destination} nehmen"
                },
                "name": {
                    "default": "In {rotary_name} fahren",
                    "name": "In {rotary_name} die Ausfahrt auf {way_name} nehmen",
                    "destination": "In {rotary_name} die Ausfahrt Richtung {destination} nehmen"
                },
                "exit": {
                    "default": "Im Kreisverkehr die {exit_number} Ausfahrt nehmen",
                    "name": "Im Kreisverkehr die {exit_number} Ausfahrt nehmen auf {way_name}",
                    "destination": "Im Kreisverkehr die {exit_number} Ausfahrt nehmen Richtung {destination}"
                },
                "name_exit": {
                    "default": "In den Kreisverkehr fahren und {exit_number} Ausfahrt nehmen",
                    "name": "In den Kreisverkehr fahren und {exit_number} Ausfahrt nehmen auf {way_name}",
                    "destination": "In den Kreisverkehr fahren und {exit_number} Ausfahrt nehmen Richtung {destination}"
                }
            }
        },
        "roundabout": {
            "default": {
                "exit": {
                    "default": "Im Kreisverkehr die {exit_number} Ausfahrt nehmen",
                    "name": "Im Kreisverkehr die {exit_number} Ausfahrt nehmen auf {way_name}",
                    "destination": "Im Kreisverkehr die {exit_number} Ausfahrt nehmen Richtung {destination}"
                },
                "default": {
                    "default": "In den Kreisverkehr fahren",
                    "name": "Im Kreisverkehr die Ausfahrt auf {way_name} nehmen",
                    "destination": "Im Kreisverkehr die Ausfahrt Richtung {destination} nehmen"
                }
            }
        },
        "roundabout turn": {
            "default": {
                "default": "{modifier} abbiegen",
                "name": "{modifier} abbiegen auf {way_name}",
                "destination": "{modifier} abbiegen Richtung {destination}"
            },
            "left": {
                "default": "Links abbiegen",
                "name": "Links abbiegen auf {way_name}",
                "destination": "Links abbiegen Richtung {destination}"
            },
            "right": {
                "default": "Rechts abbiegen",
                "name": "Rechts abbiegen auf {way_name}",
                "destination": "Rechts abbiegen Richtung {destination}"
            },
            "straight": {
                "default": "Geradeaus weiterfahren",
                "name": "Geradeaus weiterfahren auf {way_name}",
                "destination": "Geradeaus weiterfahren Richtung {destination}"
            }
        },
        "exit roundabout": {
            "default": {
                "default": "{modifier} abbiegen",
                "name": "{modifier} abbiegen auf {way_name}",
                "destination": "{modifier} abbiegen Richtung {destination}"
            },
            "left": {
                "default": "Links abbiegen",
                "name": "Links abbiegen auf {way_name}",
                "destination": "Links abbiegen Richtung {destination}"
            },
            "right": {
                "default": "Rechts abbiegen",
                "name": "Rechts abbiegen auf {way_name}",
                "destination": "Rechts abbiegen Richtung {destination}"
            },
            "straight": {
                "default": "Geradeaus weiterfahren",
                "name": "Geradeaus weiterfahren auf {way_name}",
                "destination": "Geradeaus weiterfahren Richtung {destination}"
            }
        },
        "exit rotary": {
            "default": {
                "default": "{modifier} abbiegen",
                "name": "{modifier} abbiegen auf {way_name}",
                "destination": "{modifier} abbiegen Richtung {destination}"
            },
            "left": {
                "default": "Links abbiegen",
                "name": "Links abbiegen auf {way_name}",
                "destination": "Links abbiegen Richtung {destination}"
            },
            "right": {
                "default": "Rechts abbiegen",
                "name": "Rechts abbiegen auf {way_name}",
                "destination": "Rechts abbiegen Richtung {destination}"
            },
            "straight": {
                "default": "Geradeaus weiterfahren",
                "name": "Geradeaus weiterfahren auf {way_name}",
                "destination": "Geradeaus weiterfahren Richtung {destination}"
            }
        },
        "turn": {
            "default": {
                "default": "{modifier} abbiegen",
                "name": "{modifier} abbiegen auf {way_name}",
                "destination": "{modifier} abbiegen Richtung {destination}",
                "junction_name": "Make a {modifier} at {junction_name}"
            },
            "left": {
                "default": "Links abbiegen",
                "name": "Links abbiegen auf {way_name}",
                "destination": "Links abbiegen Richtung {destination}",
                "junction_name": "Links abbiegen an {junction_name}"
            },
            "right": {
                "default": "Rechts abbiegen",
                "name": "Rechts abbiegen auf {way_name}",
                "destination": "Rechts abbiegen Richtung {destination}",
                "junction_name": "Rechts abbiegen an {junction_name}"
            },
            "straight": {
                "default": "Geradeaus weiterfahren",
                "name": "Geradeaus weiterfahren auf {way_name}",
                "destination": "Geradeaus weiterfahren Richtung {destination}",
                "junction_name": "Geradeaus weiterfahren an {junction_name}"
            }
        },
        "use lane": {
            "no_lanes": {
                "default": "Geradeaus weiterfahren"
            },
            "default": {
                "default": "{lane_instruction}"
            }
        }
    }
},
"es":{
    "meta": {
        "capitalizeFirstLetter": true
    },
    "v5": {
        "constants": {
            "ordinalize": {
                "1": "1ª",
                "2": "2ª",
                "3": "3ª",
                "4": "4ª",
                "5": "5ª",
                "6": "6ª",
                "7": "7ª",
                "8": "8ª",
                "9": "9ª",
                "10": "10ª"
            },
            "direction": {
                "north": "norte",
                "northeast": "noreste",
                "east": "este",
                "southeast": "sureste",
                "south": "sur",
                "southwest": "suroeste",
                "west": "oeste",
                "northwest": "noroeste"
            },
            "modifier": {
                "left": "izquierda",
                "right": "derecha",
                "sharp left": "cerrada a la izquierda",
                "sharp right": "cerrada a la derecha",
                "slight left": "levemente a la izquierda",
                "slight right": "levemente a la derecha",
                "straight": "recto",
                "uturn": "cambio de sentido"
            },
            "lanes": {
                "xo": "Mantente a la derecha",
                "ox": "Mantente a la izquierda",
                "xox": "Mantente en el medio",
                "oxo": "Mantente a la izquierda o derecha"
            }
        },
        "modes": {
            "ferry": {
                "default": "Coge el ferry",
                "name": "Coge el ferry {way_name}",
                "destination": "Coge el ferry a {destination}"
            }
        },
        "phrase": {
            "two linked by distance": "{instruction_one} y luego a {distance}, {instruction_two}",
            "two linked": "{instruction_one} y luego {instruction_two}",
            "one in distance": "A {distance}, {instruction_one}",
            "name and ref": "{name} ({ref})",
            "exit with number": "salida {exit}"
        },
        "arrive": {
            "default": {
                "default": "Has llegado a tu {nth} destino",
                "upcoming": "Vas a llegar a tu {nth} destino",
                "short": "Has llegado",
                "short-upcoming": "Vas a llegar",
                "named": "Has llegado a {waypoint_name}"
            },
            "left": {
                "default": "Has llegado a tu {nth} destino, a la izquierda",
                "upcoming": "Vas a llegar a tu {nth} destino, a la izquierda",
                "short": "Has llegado",
                "short-upcoming": "Vas a llegar",
                "named": "Has llegado a {waypoint_name}, a la izquierda"
            },
            "right": {
                "default": "Has llegado a tu {nth} destino, a la derecha",
                "upcoming": "Vas a llegar a tu {nth} destino, a la derecha",
                "short": "Has llegado",
                "short-upcoming": "Vas a llegar",
                "named": "Has llegado a {waypoint_name}, a la derecha"
            },
            "sharp left": {
                "default": "Has llegado a tu {nth} destino, a la izquierda",
                "upcoming": "Vas a llegar a tu {nth} destino, a la izquierda",
                "short": "Has llegado",
                "short-upcoming": "Vas a llegar",
                "named": "Has llegado a {waypoint_name}, a la izquierda"
            },
            "sharp right": {
                "default": "Has llegado a tu {nth} destino, a la derecha",
                "upcoming": "Vas a llegar a tu {nth} destino, a la derecha",
                "short": "Has llegado",
                "short-upcoming": "Vas a llegar",
                "named": "Has llegado a {waypoint_name}, a la derecha"
            },
            "slight right": {
                "default": "Has llegado a tu {nth} destino, a la derecha",
                "upcoming": "Vas a llegar a tu {nth} destino, a la derecha",
                "short": "Has llegado",
                "short-upcoming": "Vas a llegar",
                "named": "Has llegado a {waypoint_name}, a la derecha"
            },
            "slight left": {
                "default": "Has llegado a tu {nth} destino, a la izquierda",
                "upcoming": "Vas a llegar a tu {nth} destino, a la izquierda",
                "short": "Has llegado",
                "short-upcoming": "Vas a llegar",
                "named": "Has llegado a {waypoint_name}, a la izquierda"
            },
            "straight": {
                "default": "Has llegado a tu {nth} destino, en frente",
                "upcoming": "Vas a llegar a tu {nth} destino, en frente",
                "short": "Has llegado",
                "short-upcoming": "Vas a llegar",
                "named": "Has llegado a {waypoint_name}, en frente"
            }
        },
        "continue": {
            "default": {
                "default": "Gira a {modifier}",
                "name": "Cruza a la{modifier}  en {way_name}",
                "destination": "Gira a {modifier} hacia {destination}",
                "exit": "Gira a {modifier} en {way_name}"
            },
            "straight": {
                "default": "Continúa recto",
                "name": "Continúa en {way_name}",
                "destination": "Continúa hacia {destination}",
                "distance": "Continúa recto por {distance}",
                "namedistance": "Continúa recto en {way_name} por {distance}"
            },
            "sharp left": {
                "default": "Gira a la izquierda",
                "name": "Gira a la izquierda en {way_name}",
                "destination": "Gira a la izquierda hacia {destination}",
                "junction_name": "Gira a la izquierda en {junction_name}"
            },
            "sharp right": {
                "default": "Gira a la derecha",
                "name": "Gira a la derecha en {way_name}",
                "destination": "Gira a la derecha hacia {destination}",
                "junction_name": "Gira a la derecha en {junction_name}"
            },
            "slight left": {
                "default": "Gira a la izquierda",
                "name": "Dobla levemente a la izquierda en {way_name}",
                "destination": "Gira a la izquierda hacia {destination}",
                "junction_name": "Dobla levemente a la izquierda en {junction_name}"
            },
            "slight right": {
                "default": "Gira a la izquierda",
                "name": "Dobla levemente a la derecha en {way_name}",
                "destination": "Gira a la izquierda hacia {destination}",
                "junction_name": "Dobla levemente a la derecha en {junction_name}"
            },
            "uturn": {
                "default": "Haz un cambio de sentido",
                "name": "Haz un cambio de sentido y continúa en {way_name}",
                "destination": "Haz un cambio de sentido hacia {destination}",
                "junction_name": "Haz un cambio de sentido en {junction_name}"
            }
        },
        "depart": {
            "default": {
                "default": "Ve a {direction}",
                "name": "Ve a {direction} en {way_name}",
                "namedistance": "Ve a {direction} en {way_name} por {distance}"
            }
        },
        "end of road": {
            "default": {
                "default": "Gira a {modifier}",
                "name": "Gira a {modifier} en {way_name}",
                "destination": "Gira a {modifier} hacia {destination}",
                "junction_name": "Gira a {modifier} en {junction_name}"
            },
            "straight": {
                "default": "Continúa recto",
                "name": "Continúa recto en {way_name}",
                "destination": "Continúa recto hacia {destination}",
                "junction_name": "Continúa recto en {junction_name}"
            },
            "uturn": {
                "default": "Haz un cambio de sentido al final de la via",
                "name": "Haz un cambio de sentido en {way_name} al final de la via",
                "destination": "Haz un cambio de sentido hacia {destination} al final de la via",
                "junction_name": "Haz un cambio de sentido en {junction_name}"
            }
        },
        "fork": {
            "default": {
                "default": "Mantente {modifier} en el cruza",
                "name": "Mantente {modifier} en {way_name}",
                "destination": "Mantente {modifier} hacia {destination}"
            },
            "slight left": {
                "default": "Mantente a la izquierda en el cruza",
                "name": "Mantente a la izquierda en {way_name}",
                "destination": "Mantente a la izquierda hacia {destination}"
            },
            "slight right": {
                "default": "Mantente a la derecha en el cruza",
                "name": "Mantente a la derecha en {way_name}",
                "destination": "Mantente a la derecha hacia {destination}"
            },
            "sharp left": {
                "default": "Gira a la izquierda en el cruza",
                "name": "Gira a la izquierda en {way_name}",
                "destination": "Gira a la izquierda hacia {destination}"
            },
            "sharp right": {
                "default": "Gira a la derecha en el cruza",
                "name": "Gira a la derecha en {way_name}",
                "destination": "Gira a la derecha hacia {destination}"
            },
            "uturn": {
                "default": "Haz un cambio de sentido",
                "name": "Haz un cambio de sentido en {way_name}",
                "destination": "Haz un cambio de sentido hacia {destination}"
            }
        },
        "merge": {
            "default": {
                "default": "Incorpórate a {modifier}",
                "name": "Incorpórate a {modifier} en {way_name}",
                "destination": "Incorpórate a {modifier} hacia {destination}"
            },
            "straight": {
                "default": "Incorpórate",
                "name": "Incorpórate a {way_name}",
                "destination": "Incorpórate hacia {destination}"
            },
            "slight left": {
                "default": "Incorpórate a la izquierda",
                "name": "Incorpórate a la izquierda en {way_name}",
                "destination": "Incorpórate a la izquierda hacia {destination}"
            },
            "slight right": {
                "default": "Incorpórate a la derecha",
                "name": "Incorpórate a la derecha en {way_name}",
                "destination": "Incorpórate a la derecha hacia {destination}"
            },
            "sharp left": {
                "default": "Incorpórate a la izquierda",
                "name": "Incorpórate a la izquierda en {way_name}",
                "destination": "Incorpórate a la izquierda hacia {destination}"
            },
            "sharp right": {
                "default": "Incorpórate a la derecha",
                "name": "Incorpórate a la derecha en {way_name}",
                "destination": "Incorpórate a la derecha hacia {destination}"
            },
            "uturn": {
                "default": "Haz un cambio de sentido",
                "name": "Haz un cambio de sentido en {way_name}",
                "destination": "Haz un cambio de sentido hacia {destination}"
            }
        },
        "new name": {
            "default": {
                "default": "Continúa {modifier}",
                "name": "Continúa {modifier} en {way_name}",
                "destination": "Continúa {modifier} hacia {destination}"
            },
            "straight": {
                "default": "Continúa recto",
                "name": "Continúa en {way_name}",
                "destination": "Continúa hacia {destination}"
            },
            "sharp left": {
                "default": "Gira a la izquierda",
                "name": "Gira a la izquierda en {way_name}",
                "destination": "Gira a la izquierda hacia {destination}"
            },
            "sharp right": {
                "default": "Gira a la derecha",
                "name": "Gira a la derecha en {way_name}",
                "destination": "Gira a la derecha hacia {destination}"
            },
            "slight left": {
                "default": "Continúa levemente a la izquierda",
                "name": "Continúa levemente a la izquierda en {way_name}",
                "destination": "Continúa levemente a la izquierda hacia {destination}"
            },
            "slight right": {
                "default": "Continúa levemente a la derecha",
                "name": "Continúa levemente a la derecha en {way_name}",
                "destination": "Continúa levemente a la derecha hacia {destination}"
            },
            "uturn": {
                "default": "Haz un cambio de sentido",
                "name": "Haz un cambio de sentido en {way_name}",
                "destination": "Haz un cambio de sentido hacia {destination}"
            }
        },
        "notification": {
            "default": {
                "default": "Continúa {modifier}",
                "name": "Continúa {modifier} en {way_name}",
                "destination": "Continúa {modifier} hacia {destination}"
            },
            "uturn": {
                "default": "Haz un cambio de sentido",
                "name": "Haz un cambio de sentido en {way_name}",
                "destination": "Haz un cambio de sentido hacia {destination}"
            }
        },
        "off ramp": {
            "default": {
                "default": "Toma la salida",
                "name": "Toma la salida en {way_name}",
                "destination": "Toma la salida hacia {destination}",
                "exit": "Toma la salida {exit}",
                "exit_destination": "Toma la salida {exit} hacia {destination}"
            },
            "left": {
                "default": "Toma la salida en la izquierda",
                "name": "Toma la salida en la izquierda en {way_name}",
                "destination": "Toma la salida en la izquierda en {destination}",
                "exit": "Toma la salida {exit} en la izquierda",
                "exit_destination": "Toma la salida {exit} en la izquierda hacia {destination}"
            },
            "right": {
                "default": "Toma la salida en la derecha",
                "name": "Toma la salida en la derecha en {way_name}",
                "destination": "Toma la salida en la derecha hacia {destination}",
                "exit": "Toma la salida {exit} en la derecha",
                "exit_destination": "Toma la salida {exit} en la derecha hacia {destination}"
            },
            "sharp left": {
                "default": "Ve cuesta abajo en la izquierda",
                "name": "Ve cuesta abajo en la izquierda en {way_name}",
                "destination": "Ve cuesta abajo en la izquierda hacia {destination}",
                "exit": "Toma la salida {exit} en la izquierda",
                "exit_destination": "Toma la salida {exit} en la izquierda hacia {destination}"
            },
            "sharp right": {
                "default": "Ve cuesta abajo en la derecha",
                "name": "Ve cuesta abajo en la derecha en {way_name}",
                "destination": "Ve cuesta abajo en la derecha hacia {destination}",
                "exit": "Toma la salida {exit} en la derecha",
                "exit_destination": "Toma la salida {exit} en la derecha hacia {destination}"
            },
            "slight left": {
                "default": "Ve cuesta abajo en la izquierda",
                "name": "Ve cuesta abajo en la izquierda en {way_name}",
                "destination": "Ve cuesta abajo en la izquierda hacia {destination}",
                "exit": "Toma la salida {exit} en la izquierda",
                "exit_destination": "Toma la salida {exit} en la izquierda hacia {destination}"
            },
            "slight right": {
                "default": "Toma la salida en la derecha",
                "name": "Toma la salida en la derecha en {way_name}",
                "destination": "Toma la salida en la derecha hacia {destination}",
                "exit": "Toma la salida {exit} en la derecha",
                "exit_destination": "Toma la salida {exit} en la derecha hacia {destination}"
            }
        },
        "on ramp": {
            "default": {
                "default": "Toma la rampa",
                "name": "Toma la rampa en {way_name}",
                "destination": "Toma la rampa hacia {destination}"
            },
            "left": {
                "default": "Toma la rampa en la izquierda",
                "name": "Toma la rampa en la izquierda en {way_name}",
                "destination": "Toma la rampa en la izquierda hacia {destination}"
            },
            "right": {
                "default": "Toma la rampa en la derecha",
                "name": "Toma la rampa en la derecha en {way_name}",
                "destination": "Toma la rampa en la derecha hacia {destination}"
            },
            "sharp left": {
                "default": "Toma la rampa en la izquierda",
                "name": "Toma la rampa en la izquierda en {way_name}",
                "destination": "Toma la rampa en la izquierda hacia {destination}"
            },
            "sharp right": {
                "default": "Toma la rampa en la derecha",
                "name": "Toma la rampa en la derecha en {way_name}",
                "destination": "Toma la rampa en la derecha hacia {destination}"
            },
            "slight left": {
                "default": "Toma la rampa en la izquierda",
                "name": "Toma la rampa en la izquierda en {way_name}",
                "destination": "Toma la rampa en la izquierda hacia {destination}"
            },
            "slight right": {
                "default": "Toma la rampa en la derecha",
                "name": "Toma la rampa en la derecha en {way_name}",
                "destination": "Toma la rampa en la derecha hacia {destination}"
            }
        },
        "rotary": {
            "default": {
                "default": {
                    "default": "Entra en la rotonda",
                    "name": "Entra en la rotonda y sal en {way_name}",
                    "destination": "Entra en la rotonda y sal hacia {destination}"
                },
                "name": {
                    "default": "Entra en {rotary_name}",
                    "name": "Entra en {rotary_name} y sal en {way_name}",
                    "destination": "Entra en {rotary_name} y sal hacia {destination}"
                },
                "exit": {
                    "default": "Entra en la rotonda y toma la {exit_number} salida",
                    "name": "Entra en la rotonda y toma la {exit_number} salida a {way_name}",
                    "destination": "Entra en la rotonda y toma la {exit_number} salida hacia {destination}"
                },
                "name_exit": {
                    "default": "Entra en {rotary_name} y coge la {exit_number} salida",
                    "name": "Entra en {rotary_name} y coge la {exit_number} salida en {way_name}",
                    "destination": "Entra en {rotary_name} y coge la {exit_number} salida hacia {destination}"
                }
            }
        },
        "roundabout": {
            "default": {
                "exit": {
                    "default": "Entra en la rotonda y toma la {exit_number} salida",
                    "name": "Entra en la rotonda y toma la {exit_number} salida a {way_name}",
                    "destination": "Entra en la rotonda y toma la {exit_number} salida hacia {destination}"
                },
                "default": {
                    "default": "Entra en la rotonda",
                    "name": "Entra en la rotonda y sal en {way_name}",
                    "destination": "Entra en la rotonda y sal hacia {destination}"
                }
            }
        },
        "roundabout turn": {
            "default": {
                "default": "Sigue {modifier}",
                "name": "Sigue {modifier} en {way_name}",
                "destination": "Sigue {modifier} hacia {destination}"
            },
            "left": {
                "default": "Gira a la izquierda",
                "name": "Gira a la izquierda en {way_name}",
                "destination": "Gira a la izquierda hacia {destination}"
            },
            "right": {
                "default": "Gira a la derecha",
                "name": "Gira a la derecha en {way_name}",
                "destination": "Gira a la derecha hacia {destination}"
            },
            "straight": {
                "default": "Continúa recto",
                "name": "Continúa recto en {way_name}",
                "destination": "Continúa recto hacia {destination}"
            }
        },
        "exit roundabout": {
            "default": {
                "default": "Sal la rotonda",
                "name": "Sal la rotonda en {way_name}",
                "destination": "Sal la rotonda hacia {destination}"
            }
        },
        "exit rotary": {
            "default": {
                "default": "Sal la rotonda",
                "name": "Sal la rotonda en {way_name}",
                "destination": "Sal la rotonda hacia {destination}"
            }
        },
        "turn": {
            "default": {
                "default": "Sigue {modifier}",
                "name": "Sigue {modifier} en {way_name}",
                "destination": "Sigue {modifier} hacia {destination}",
                "junction_name": "Sigue {modifier} en {junction_name}"
            },
            "left": {
                "default": "Gira a la izquierda",
                "name": "Gira a la izquierda en {way_name}",
                "destination": "Gira a la izquierda hacia {destination}",
                "junction_name": "Gira a la izquierda en {junction_name}"
            },
            "right": {
                "default": "Gira a la derecha",
                "name": "Gira a la derecha en {way_name}",
                "destination": "Gira a la derecha hacia {destination}",
                "junction_name": "Gira a la derecha en {junction_name}"
            },
            "straight": {
                "default": "Ve recto",
                "name": "Ve recto en {way_name}",
                "destination": "Ve recto hacia {destination}",
                "junction_name": "Ve recto en {junction_name}"
            }
        },
        "use lane": {
            "no_lanes": {
                "default": "Continúa recto"
            },
            "default": {
                "default": "{lane_instruction}"
            }
        }
    }
}
}''';
