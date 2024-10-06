package InteroperabilityLiveDemonstrator {
    package <BA> Drone_BaseArchitecture {
        // Common concept of a Drone

        abstract part def CommonDrone {
            // Mass of the Drone
            attribute actualMass :> ISQ::mass;

            // Spatial extent
            item boundingBox : ShapeItems::Box [1] :> boundingShapes;
        }
    }

    package DroneModel {
        // a concrete drone
        part forestFireObservationDrone : PA::Drone;

        // Requirement satisfaction
        satisfy RE::REQ1 by forestFireObservationDrone;
        satisfy RE::REQ6 by forestFireObservationDrone;

        //
        // Requirements
        //
        package <RE> Drone_Requirements {
            requirement <REQ1> height {
                doc
                /*
                 * The drone shall not be higher than the maximumHeight of 60 cm.
                 */
                subject d : BA::CommonDrone;

                attribute maximumHeight :> ISQ::length = 60 [SI::cm];

                require constraint {
                    d.boundingBox.height <= maximumHeight
                }
            }
            requirement <REQ6> lightweight {
                doc
                /*
                 * The drone shall not weigh more than maximumMass of 8 kg.
                 */
                subject d : BA::CommonDrone;

                attribute maximumMass :> ISQ::mass = 8 [SI::kg];

                require constraint {
                    d.actualMass <= maximumMass
                }
            }
        }

        //
        // Physical Architecture
        //
        package <PA> Drone_PhysicalArchitecture {
            //
            // Drone
            //
            part def Drone :> BA::CommonDrone {
                // Attributes
                attribute :>> actualMass =
                    battery.actualMass + body.actualMass + QuantityCalculations::sum(engines.actualMass);

                // Spatial extent = Spatial extent of the body
                item :>> boundingBox = body.boundingBox;

                // Power
                part battery : DroneBattery;

                // Engines
                part engines : DroneEngine [6];
                part engine1 :> engines {
                    attribute :>> actualMass = 100 [SI::g];
                    attribute :>> propKind = PropKind::clockwise;
                }
                part engine2 :> engines {
                    attribute :>> actualMass = 100 [SI::g];
                    attribute :>> propKind = PropKind::counterclockwise;
                }
                part engine3 :> engines {
                    attribute :>> actualMass = 100 [SI::g];
                    attribute :>> propKind = PropKind::clockwise;
                }
                part engine4 :> engines {
                    attribute :>> actualMass = 100 [SI::g];
                    attribute :>> propKind = PropKind::counterclockwise;
                }
                part engine5 :> engines {
                    attribute :>> actualMass = 100 [SI::g];
                    attribute :>> propKind = PropKind::clockwise;
                }
                part engine6 :> engines {
                    attribute :>> actualMass = 100 [SI::g];
                    attribute :>> propKind = PropKind::counterclockwise;
                }

                // Body
                part body : DroneBody {
                    attribute :>> actualMass = 0 [SI::g];
                    attribute :>> material = "Aluminium";
                    part :>> rotors [6];
                    part :>> arms [3];
                }

                // Connections
                connect battery to engines;
                connect battery to body;
                connect engines to body;
            }

            //
            // Drone Engine
            //
            part def DroneEngine {
                // Attributes
                attribute actualMass : ISQBase::MassValue;

                enum propKind : PropKind;
                enum def PropKind {
                    enum clockwise;
                    enum counterclockwise;
                }
            }

            //
            // Drone Body
            //
            part def DroneBody {
                // Attributes
                attribute actualMass :> ISQ::mass;
                attribute material : ScalarValues::String;

                // Spatial extent
                item :>> shape : ShapeItems::Cylinder {
                    attribute :>> height = 0 [SI::cm];
                    item :>> base.shape : ShapeItems::Circle {
                        attribute :>> radius = 0 [SI::cm];
                    }
                }
                item boundingBox : ShapeItems::Box [1] :> boundingShapes {
                    attribute :>> length = 0 [SI::cm];
                    attribute :>> width = 0 [SI::cm];
                    attribute :>> height = 0 [SI::cm];
                }
                part rotors [*];
                part arms [*];
                connect rotors to arms;
                part landingGear;
                part coreBody;
            }

            //
            // Drone Battery
            //
            part def DroneBattery {
                // Attributes
                attribute actualMass :> ISQ::mass = 0 [SI::g];
                attribute maxCapacity :> ISQ::electricCharge = 18000 [SI::C];
            }
        }
    }
}
