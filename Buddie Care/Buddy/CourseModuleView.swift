import SwiftUI

// MARK: - Module types

enum ModuleType { case video, quiz, reading }

struct CourseModuleView: View {
    let courseTitle: String
    let moduleTitle: String
    let type: ModuleType
    let durationMinutes: Int
    let onComplete: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                switch type {
                case .video: videoContent
                case .quiz: QuizContent(courseTitle: courseTitle, onPass: onComplete)
                case .reading: readingContent
                }
            }
            .navigationTitle(moduleTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Sluiten") { dismiss() }.tint(BCColors.primary)
                }
            }
            .background(BCColors.background.ignoresSafeArea())
        }
    }

    // MARK: - Video

    private var videoContent: some View {
        VStack(spacing: BCSpacing.lg) {
            ScrollView {
                VStack(spacing: BCSpacing.lg) {
                    ZStack {
                        RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                            .fill(Color.black.opacity(0.85))
                            .frame(height: 220)
                        VStack(spacing: BCSpacing.sm) {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 56))
                                .foregroundStyle(.white.opacity(0.9))
                            Text("\(durationMinutes) min")
                                .font(BCTypography.captionEmphasized)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    }
                    .padding(.horizontal, BCSpacing.lg)

                    BCCard {
                        VStack(alignment: .leading, spacing: BCSpacing.xs) {
                            Label("Video niet beschikbaar", systemImage: "info.circle.fill")
                                .font(BCTypography.captionEmphasized)
                                .foregroundStyle(BCColors.textSecondary)
                            // TODO[real-content]: Upload video for this module
                            Text("Video wordt binnenkort toegevoegd. Klik op 'Markeer als bekeken' om verder te gaan.")
                                .font(BCTypography.caption)
                                .foregroundStyle(BCColors.textTertiary)
                        }
                    }
                    .padding(.horizontal, BCSpacing.lg)
                }
                .padding(.vertical, BCSpacing.lg)
            }

            Divider()
            BCPrimaryButton(title: "Markeer als bekeken", icon: "checkmark.circle.fill") {
                onComplete()
                dismiss()
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.bottom, BCSpacing.md)
        }
    }

    // MARK: - Reading

    private var readingContent: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: BCSpacing.md) {
                    BCCard {
                        HStack(spacing: BCSpacing.sm) {
                            Image(systemName: "clock")
                                .foregroundStyle(BCColors.textSecondary)
                            Text("Leestijd: ca. \(durationMinutes) minuten")
                                .font(BCTypography.caption)
                                .foregroundStyle(BCColors.textSecondary)
                        }
                    }

                    // TODO[real-content]: Replace with actual module content
                    Text(mockReadingContent)
                        .font(BCTypography.body)
                        .foregroundStyle(BCColors.textPrimary)
                        .lineSpacing(6)
                }
                .padding(BCSpacing.lg)
            }

            Divider()
            BCPrimaryButton(title: "Klaar met lezen", icon: "checkmark.circle.fill") {
                onComplete()
                dismiss()
            }
            .padding(.horizontal, BCSpacing.lg)
            .padding(.bottom, BCSpacing.md)
        }
    }
}

// MARK: - Quiz Content

private struct QuizContent: View {
    let courseTitle: String
    let onPass: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var currentQuestion: Int = 0
    @State private var selectedAnswer: Int? = nil
    @State private var answers: [Int] = []
    @State private var showResult: Bool = false

    private let questions: [QuizQuestion] = [
        QuizQuestion(
            question: "Wat is de minimale leeftijd om buddy te worden bij Buddy Care?",
            options: ["16 jaar", "18 jaar", "21 jaar", "Geen leeftijdsgrens"],
            correctIndex: 1
        ),
        QuizQuestion(
            question: "Welke handeling mag een Niveau 0 buddy NIET uitvoeren?",
            options: ["Boodschappen doen", "Gezelschap bieden", "Medicatie toedienen", "Samen wandelen"],
            correctIndex: 2
        ),
        QuizQuestion(
            question: "Wat doet u als u een incident constateert bij een oudere?",
            options: ["Niets doen", "Later melden aan familie", "Direct melden via de app", "Zelf oplossen"],
            correctIndex: 2
        ),
        QuizQuestion(
            question: "Hoe lang is een VOG geldig bij Buddy Care?",
            options: ["1 jaar", "2 jaar", "3 jaar", "5 jaar"],
            correctIndex: 2
        ),
        QuizQuestion(
            question: "Wat is de commissie die Buddy Care inhoudt op uw verdiensten?",
            options: ["10%", "15%", "20%", "25%"],
            correctIndex: 2
        )
    ]

    private var score: Int {
        zip(answers, questions).filter { $0.0 == $0.1.correctIndex }.count
    }

    private var passed: Bool { Double(score) / Double(questions.count) >= 0.8 }

    var body: some View {
        if showResult {
            resultView
        } else {
            questionView
        }
    }

    private var questionView: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: BCSpacing.md) {
                    BCProgressBar(
                        value: Double(currentQuestion) / Double(questions.count),
                        label: "Vraag \(currentQuestion + 1) van \(questions.count)"
                    )

                    Text(questions[currentQuestion].question)
                        .font(BCTypography.title3)
                        .foregroundStyle(BCColors.textPrimary)
                        .padding(.top, BCSpacing.sm)

                    VStack(spacing: BCSpacing.sm) {
                        ForEach(Array(questions[currentQuestion].options.enumerated()), id: \.offset) { idx, option in
                            Button {
                                selectedAnswer = idx
                            } label: {
                                HStack(spacing: BCSpacing.md) {
                                    ZStack {
                                        Circle()
                                            .stroke(selectedAnswer == idx ? BCColors.primary : BCColors.border, lineWidth: 2)
                                            .frame(width: 28, height: 28)
                                        if selectedAnswer == idx {
                                            Circle().fill(BCColors.primary).frame(width: 16, height: 16)
                                        }
                                    }
                                    Text(option)
                                        .font(BCTypography.body)
                                        .foregroundStyle(BCColors.textPrimary)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .padding(BCSpacing.md)
                                .frame(minHeight: 60)
                                .background(
                                    RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                                        .fill(selectedAnswer == idx ? BCColors.primaryMuted : BCColors.surface)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: BCRadius.lg, style: .continuous)
                                        .stroke(selectedAnswer == idx ? BCColors.primary : BCColors.border, lineWidth: selectedAnswer == idx ? 2 : 1)
                                )
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("Antwoordoptie \(idx + 1): \(option)")
                        }
                    }
                }
                .padding(BCSpacing.lg)
            }

            Divider()
            BCPrimaryButton(
                title: currentQuestion < questions.count - 1 ? "Volgende vraag" : "Bekijk resultaat",
                icon: currentQuestion < questions.count - 1 ? "chevron.right" : "checkmark"
            ) {
                if let answer = selectedAnswer {
                    answers.append(answer)
                    selectedAnswer = nil
                    if currentQuestion < questions.count - 1 {
                        currentQuestion += 1
                    } else {
                        showResult = true
                    }
                }
            }
            .opacity(selectedAnswer != nil ? 1.0 : 0.4)
            .disabled(selectedAnswer == nil)
            .padding(.horizontal, BCSpacing.lg)
            .padding(.bottom, BCSpacing.md)
        }
    }

    private var resultView: some View {
        VStack(spacing: BCSpacing.xl) {
            Spacer()

            Image(systemName: passed ? "checkmark.seal.fill" : "xmark.seal.fill")
                .font(.system(size: 72))
                .foregroundStyle(passed ? BCColors.success : BCColors.danger)

            VStack(spacing: BCSpacing.sm) {
                Text(passed ? "Geslaagd!" : "Niet geslaagd")
                    .font(BCTypography.title2)
                    .foregroundStyle(BCColors.textPrimary)
                Text("\(score) van de \(questions.count) vragen goed (\(Int(Double(score) / Double(questions.count) * 100))%)")
                    .font(BCTypography.body)
                    .foregroundStyle(BCColors.textSecondary)
                if !passed {
                    Text("U heeft minimaal 80% nodig om te slagen. Probeer het opnieuw.")
                        .font(BCTypography.caption)
                        .foregroundStyle(BCColors.textTertiary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, BCSpacing.lg)
                }
            }

            Spacer()

            VStack(spacing: BCSpacing.sm) {
                if passed {
                    BCPrimaryButton(title: "Certificaat ophalen", icon: "rosette") {
                        onPass()
                        dismiss()
                    }
                    .padding(.horizontal, BCSpacing.lg)
                } else {
                    BCPrimaryButton(title: "Opnieuw proberen", icon: "arrow.counterclockwise") {
                        currentQuestion = 0
                        answers = []
                        selectedAnswer = nil
                        showResult = false
                    }
                    .padding(.horizontal, BCSpacing.lg)
                    BCSecondaryButton(title: "Sluiten", icon: "xmark") { dismiss() }
                        .padding(.horizontal, BCSpacing.lg)
                }
            }
            .padding(.bottom, BCSpacing.xl)
        }
    }
}

private struct QuizQuestion {
    let question: String
    let options: [String]
    let correctIndex: Int
}

// MARK: - Mock reading content placeholder

private let mockReadingContent = """
In dit module leer je de basisprincipes van zorg voor ouderen. Goede zorg begint met respect en aandacht voor de persoon.

**Communicatie met ouderen**

Spreek duidelijk en niet te snel. Kijk de persoon aan als u spreekt. Gebruik eenvoudige taal en vermijd jargon. Geef de oudere de tijd om te reageren.

**Veiligheid**

Let altijd op de omgeving. Verwijder obstakels die kunnen leiden tot vallen. Controleer of er goede verlichting is. Meld onveilige situaties direct.

**Privacy en waardigheid**

Behandel elke oudere met respect voor zijn of haar privacy. Klop altijd aan voor u een kamer binnenkomt. Laat de oudere zo zelfstandig mogelijk zijn.

**Rapportage**

Noteer bijzonderheden in de app na elk bezoek. Wees objectief en feitelijk. Meld wijzigingen in de gezondheidstoestand aan de familie.

// TODO[real-content]: Vervang deze tekst met de werkelijke module-inhoud, goedgekeurd door een zorgdeskundige.
"""
