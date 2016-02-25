
library(shiny)

shinyUI(fluidPage(

    tags$head(tags$link(rel="stylesheet", type="text/css", href="shiny.css")),

    titlePanel("CPSC 420 -- System Dynamics examples"),

    tabsetPanel(selected="SIR",
        tabPanel("Bathtub",
            sidebarLayout(sidebarPanel(
                numericInput("bathtubSimLength", "Simulation time (min)",
                    value=5, min=0, step=.5, width="40%"),
                sliderInput("initWaterLevel", "Initial water level (gal)",
                    min=0, max=60, value=50),

                # (Putting the code for these into server.R is necessary so
                # their width can vary dynamically dependent on the
                # bathtubSimLength widget's value.)
                uiOutput("faucetOnOffWidget"),
                uiOutput("pullPlugTimeWidget"),

                div(class="container-fluid",
                    div(class="row",
                        div(class="col-lg-6", 
                            numericInput("inflowRate", "Faucet rate (gal/min)",
                                value=15, min=0, step=1)),
                        div(class="col-lg-6", 
                            numericInput("outflowRate", "Drain rate (gal/min)",
                                value=20, min=0, step=1))
                    )
                )),
                mainPanel(
                    plotOutput("bathtubWaterLevelPlot")
                )
            )
        ),
        tabPanel("Caffeine",
            sidebarLayout(sidebarPanel(
                numericInput("caffeineSimLength", "Simulation time (hrs)",
                    value=5*24, min=0, step=1, width="40%"),
                sliderInput("initStoredEnergy", "Initial stored energy (kcal)",
                    min=0, max=1e6, step=1e4, value=.5e6),
                sliderInput("initAvailableEnergy", 
                    "Initial available energy (kcal)",
                    min=0, max=2e6, step=1e4, value=1e5),
                sliderInput("lowExpenditureLevel", 
                    "Energy expenditure at rest (kcal/hr)",
                    min=0, max=5000, step=100, value=2000),
                sliderInput("highExpenditureLevel", 
                    "Energy expenditure at work (kcal/hr)",
                    min=0, max=5000, step=100, value=3000),
                sliderInput("baselineMetabolizationRate", 
                    "Baseline energy metabolization rate (kcal/hr)",
                    min=0, max=5000, step=100, value=2300),
                sliderInput("desiredAvailableEnergy", 
                    "Desired available energy (kcal)",
                    min=0, max=5e4, step=100, value=1.5e4)
            ),
            mainPanel(
                plotOutput("caffeinePlot")
            ))
        ),
        tabPanel("Coffee",
            sidebarLayout(sidebarPanel(
                numericInput("coffeeSimLength", "Simulation time (mins)",
                    value=5*24, min=0, step=1, width="40%"),
                div(class="container-fluid",
                    div(class="row",
                        div(class="col-lg-6", 
                            actionButton("runCoffeeSim",label="Start/restart")),
                        div(class="col-lg-6", 
                            actionButton("contCoffeeSim",label="Continue"))
                    )
                ),
                div(
                    h4("Initial conditions"),
                    radioButtons("mugType","Mug type",
                        choices=list("7-11 (non-insulated)"="7-11",
                            "Contiga (insulated)"="Contiga"),
                        inline=TRUE),
                    sliderInput("initCoffeeTemp", "Initial temp (°F)",
                        min=20, max=220, step=1, value=192)
                ),
                div(
                    h4("Sim parameters"),
                    sliderInput("roomTemp", "Room temp (°F)",
                        min=40, max=100, step=1, value=72)
                )
            ),
            mainPanel(
                plotOutput("coffeePlot")
            ))
        ),
        tabPanel("Interest",
            sidebarLayout(sidebarPanel(
                numericInput("interestSimLength", "Simulation time (months)",
                    value=5*12, min=0, step=1, width="40%"),
                div(
                    h4("Initial conditions"),
                    sliderInput("initBalance", "Initial balance ($)",
                        min=0, max=10e4, step=100, value=1e4)
                ),
                div(
                    h4("Sim parameters"),
                    sliderInput("interestRate", "Annual interest rate",
                        min=0, max=.4, step=.01, value=.01),
                    sliderInput("amortizationPeriod",
                        "Amortization period (months)",
                        min=1/30, max=12, step=1/30, value=1)
                )
            ),
            mainPanel(
                plotOutput("interestPlot")
            ))
        ),
        tabPanel("Reinvestment",
            sidebarLayout(sidebarPanel(
                numericInput("reinvestmentSimLength", "Simulation time (yrs)",
                    value=10, min=0, step=1, width="40%"),
                div(class="container-fluid",
                    div(class="row",
                        div(class="col-lg-6", 
                            actionButton("runReinvestmentSim",
                                label="Start/restart")),
                        div(class="col-lg-6", 
                            actionButton("contReinvestmentSim",
                                label="Continue"))
                    )
                ),
                div(
                    h4("Initial conditions"),
                    sliderInput("initialCapital", "Initial capital ($)",
                        min=1e3, max=1e5, step=1e3, value=1e4)
                ),
                div(
                    h4("Sim parameters"),
                    sliderInput("fracOutputInvested",
                        "Fraction of output reinvested",
                        min=0, max=1, step=.025, value=.2)
                )
            ),
            mainPanel(
                plotOutput("reinvestmentPlot")
            ))
        ),
        tabPanel("CPSC",
            sidebarLayout(sidebarPanel(
                numericInput("cpscLength", "Simulation time (years)",
                    value=20, min=1, step=1, width="40%"),
                div(class="container-fluid",
                    div(class="row",
                        div(class="col-lg-6", 
                            actionButton("runCpscSim",label="Start/restart")),
                        div(class="col-lg-6", 
                            actionButton("contCpscSim",label="Continue"))
                    )
                ),
                div(
                    h4("Sim parameters"),
                    sliderInput("economy", "Economy GDP ($ trillions)",
                        min=1, max=30, step=1, value=16),
                    sliderInput("rigor", "CPSC curriculum rigor",
                        min=0, max=1, step=.05, value=.5),
                    sliderInput("admissions", "Admissions policy",
                        min=0, max=1, step=.05, value=.5)
                )
            ),
            mainPanel(
                plotOutput("cpscPlot")
            ))
        ),
        tabPanel("BatsMice",
            sidebarLayout(sidebarPanel(
                numericInput("batMouseSimLength", "Simulation time (months)",
                    value=120, min=0, step=1, width="40%"),
                div(class="row",
                    div(class="col-lg-6", 
                        sliderInput("batBirthRate",
                            "Bat birth rate",
                            value=1.2, min=0, step=.1, max=3)
                    ),
                    div(class="col-lg-6", 
                        sliderInput("mouseBirthRate",
                            "Mouse birth rate",
                            value=1.2, min=0, step=.1, max=3)
                    )
                ),
                div(class="row",
                    div(class="col-lg-6", 
                        sliderInput("batDeathRate",
                            "Bat death rate",
                            value=1.5, min=0, step=.1, max=3)
                    ),
                    div(class="col-lg-6", 
                        sliderInput("mouseDeathRate",
                            "Mouse death rate",
                            value=1.1, min=0, step=.1, max=3)
                    )
                ),
                sliderInput("nutritionFactor",
                    "Nutrition factor (bats/kill)",
                    value=2, min=0, step=.1, max=5),
                sliderInput("killRatio",
                    "Kill ratio (kills/encounter)",
                    value=.05, min=0, step=.05, max=1)
            ),
            mainPanel(
                plotOutput("batsMiceTimePlot")
            ))
        ),
        tabPanel("SIR",
            sidebarLayout(sidebarPanel(
                numericInput("sirSimLength", "Simulation time (days)",
                    value=30*1, min=0, step=1, width="40%"),
                sliderInput("infectionRate",
                    "Infection rate (1/(infectedPerson*day))",
                    value=.002, min=0, step=.0005, max=.01),
                sliderInput("meanDiseaseDuration",
                    "Mean disease duration (days)",
                    value=2, min=0, step=1, max=20),
                sliderInput("initS",
                    "Initial susceptible population (people)",
                    value=780, min=0, step=10, max=2000)
            ),
            mainPanel(
                plotOutput("sirPlot")
            ))
        )
    )

))
