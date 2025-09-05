import puppeteer from "puppeteer";
import { fileURLToPath } from "url";
import { dirname, join } from "path";
import { existsSync, mkdirSync } from "fs";

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

async function generateAnamnesePDF() {
  console.log("🚀 Starte PDF-Generierung...");

  // Browser starten
  const browser = await puppeteer.launch({
    headless: "new",
    args: ["--no-sandbox", "--disable-setuid-sandbox"],
  });

  try {
    const page = await browser.newPage();

    // HTML-Inhalt für den Anamnesebogen erstellen
    const htmlContent = `
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Anamnesebogen - EMS Beckenboden Therapie</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            font-size: 12px;
            line-height: 1.4;
            color: #333;
            background: white;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #e91e63;
            padding-bottom: 15px;
        }
        
        .header h1 {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 8px;
            text-transform: uppercase;
        }
        
        .header h2 {
            font-size: 16px;
            color: #e91e63;
            margin-bottom: 15px;
        }
        
        .contact-info {
            font-size: 11px;
            color: #666;
        }
        
        .section {
            margin-bottom: 25px;
        }
        
        .section-title {
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 15px;
            padding-bottom: 5px;
            border-bottom: 2px solid #e91e63;
            text-transform: uppercase;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 10px;
        }
        
        .form-row > div {
            flex: 1;
        }
        
        .label {
            font-weight: 500;
            margin-bottom: 3px;
            display: block;
        }
        
        .input-line {
            border-bottom: 1px solid #333;
            height: 25px;
            width: 100%;
        }
        
        .input-box {
            border: 1px solid #333;
            height: 60px;
            width: 100%;
        }
        
        .checkbox-group {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 5px;
        }
        
        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 5px;
            min-width: 200px;
        }
        
        .checkbox {
            width: 12px;
            height: 12px;
            border: 1px solid #333;
            margin-right: 8px;
        }
        
        .notice {
            background: #f5f5f5;
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 25px;
            border-radius: 4px;
        }
        
        .signature-area {
            display: flex;
            gap: 40px;
            margin-top: 30px;
        }
        
        .signature-box {
            flex: 1;
            text-align: center;
        }
        
        .signature-line {
            border-bottom: 1px solid #333;
            height: 50px;
            margin-bottom: 5px;
        }
        
        .therapist-section {
            border-top: 2px solid #ccc;
            padding-top: 20px;
            margin-top: 30px;
        }
        
        @page {
            size: A4;
            margin: 1.5cm;
        }
        
        .page-break {
            page-break-before: always;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <h1>Anamnesebogen</h1>
            <h2>EMS Beckenboden Therapie</h2>
            <div class="contact-info">
                <div><strong>Annette Fneiche</strong></div>
                <div>Telefon: (07131) 4050729 | E-Mail: hallo@annette-fneiche.de</div>
            </div>
        </div>

        <!-- Hinweise -->
        <div class="notice">
            <strong>Liebe Patientin, lieber Patient,</strong><br>
            bitte füllen Sie diesen Bogen vollständig aus und bringen Sie ihn zu Ihrem ersten Termin mit. 
            Ihre Angaben helfen uns dabei, eine optimale und individuelle Behandlung für Sie zu planen.
        </div>

        <!-- 1. Persönliche Daten -->
        <div class="section">
            <div class="section-title">1. Persönliche Daten</div>
            
            <div class="form-row">
                <div>
                    <span class="label">Nachname:</span>
                    <div class="input-line"></div>
                </div>
                <div>
                    <span class="label">Vorname:</span>
                    <div class="input-line"></div>
                </div>
            </div>

            <div class="form-row">
                <div>
                    <span class="label">Geburtsdatum:</span>
                    <div class="input-line"></div>
                </div>
                <div>
                    <span class="label">Alter:</span>
                    <div class="input-line"></div>
                </div>
                <div>
                    <span class="label">Geschlecht:</span>
                    <div class="checkbox-group">
                        <div class="checkbox-item">
                            <div class="checkbox"></div> weiblich
                        </div>
                        <div class="checkbox-item">
                            <div class="checkbox"></div> männlich
                        </div>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <span class="label">Anschrift (Straße, PLZ, Ort):</span>
                <div class="input-line" style="margin-bottom: 8px;"></div>
                <div class="input-line"></div>
            </div>

            <div class="form-row">
                <div>
                    <span class="label">Telefon:</span>
                    <div class="input-line"></div>
                </div>
                <div>
                    <span class="label">E-Mail:</span>
                    <div class="input-line"></div>
                </div>
            </div>
        </div>

        <!-- 2. Aktuelle Beschwerden -->
        <div class="section">
            <div class="section-title">2. Aktuelle Beschwerden</div>
            
            <div class="form-group">
                <span class="label">Was führt Sie zu uns? (Mehrfachnennung möglich)</span>
                <div class="checkbox-group">
                    <div class="checkbox-item">
                        <div class="checkbox"></div> Harninkontinenz (unkontrollierter Harnverlust)
                    </div>
                    <div class="checkbox-item">
                        <div class="checkbox"></div> Stuhlinkontinenz (unkontrollierter Stuhlverlust)
                    </div>
                    <div class="checkbox-item">
                        <div class="checkbox"></div> Rückbildung nach Schwangerschaft
                    </div>
                    <div class="checkbox-item">
                        <div class="checkbox"></div> Beckenbodenschwäche
                    </div>
                    <div class="checkbox-item">
                        <div class="checkbox"></div> Sexuelle Probleme
                    </div>
                    <div class="checkbox-item">
                        <div class="checkbox"></div> Rückenschmerzen
                    </div>
                    <div class="checkbox-item">
                        <div class="checkbox"></div> Senkungsbeschwerden
                    </div>
                    <div class="checkbox-item">
                        <div class="checkbox"></div> Vorbeugende Stärkung
                    </div>
                </div>
            </div>

            <div class="form-group">
                <span class="label">Sonstige Beschwerden:</span>
                <div class="input-box"></div>
            </div>

            <div class="form-group">
                <span class="label">Seit wann bestehen die Beschwerden?</span>
                <div class="input-line"></div>
            </div>

            <div class="form-group">
                <span class="label">Schweregrad der Beschwerden:</span>
                <div class="checkbox-group">
                    <div class="checkbox-item">
                        <div class="checkbox"></div> leicht
                    </div>
                    <div class="checkbox-item">
                        <div class="checkbox"></div> mittel
                    </div>
                    <div class="checkbox-item">
                        <div class="checkbox"></div> stark
                    </div>
                    <div class="checkbox-item">
                        <div class="checkbox"></div> sehr stark
                    </div>
                </div>
            </div>
        </div>

        <!-- 3. Medizinische Vorgeschichte -->
        <div class="section">
            <div class="section-title">3. Medizinische Vorgeschichte</div>
            
            <div class="form-group">
                <span class="label">Schwangerschaften und Geburten:</span>
                <div class="form-row">
                    <div>
                        <span class="label">Anzahl Schwangerschaften:</span>
                        <div class="input-line"></div>
                    </div>
                    <div>
                        <span class="label">Anzahl Geburten:</span>
                        <div class="input-line"></div>
                    </div>
                    <div>
                        <span class="label">Datum letzte Geburt:</span>
                        <div class="input-line"></div>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <span class="label">Art der Entbindung(en):</span>
                <div class="checkbox-group">
                    <div class="checkbox-item">
                        <div class="checkbox"></div> Spontangeburt
                    </div>
                    <div class="checkbox-item">
                        <div class="checkbox"></div> Kaiserschnitt
                    </div>
                    <div class="checkbox-item">
                        <div class="checkbox"></div> Saugglocke/Zange
                    </div>
                    <div class="checkbox-item">
                        <div class="checkbox"></div> Episiotomie (Dammschnitt)
                    </div>
                </div>
            </div>

            <div class="form-group">
                <span class="label">Operationen im Beckenbereich:</span>
                <div class="input-box"></div>
            </div>

            <div class="form-group">
                <span class="label">Aktuelle Medikamente:</span>
                <div class="input-box"></div>
            </div>

            <div class="form-group">
                <span class="label">Bekannte Allergien:</span>
                <div class="input-box"></div>
            </div>

            <div class="form-group">
                <span class="label">Chronische Erkrankungen:</span>
                <div class="input-box"></div>
            </div>
        </div>

        <!-- 4. Lebensstil -->
        <div class="section">
            <div class="section-title">4. Lebensstil</div>
            
            <div class="form-group">
                <span class="label">Sportliche Aktivitäten:</span>
                <div class="input-box"></div>
            </div>

            <div class="form-group">
                <span class="label">Berufliche Tätigkeit:</span>
                <div class="checkbox-group">
                    <div class="checkbox-item">
                        <div class="checkbox"></div> überwiegend sitzend
                    </div>
                    <div class="checkbox-item">
                        <div class="checkbox"></div> überwiegend stehend
                    </div>
                    <div class="checkbox-item">
                        <div class="checkbox"></div> körperlich belastend
                    </div>
                </div>
            </div>

            <div class="form-group">
                <span class="label">Haben Sie schon einmal Beckenbodentraining gemacht?</span>
                <div class="checkbox-group">
                    <div class="checkbox-item">
                        <div class="checkbox"></div> Ja
                    </div>
                    <div class="checkbox-item">
                        <div class="checkbox"></div> Nein
                    </div>
                </div>
                <div style="margin-top: 10px;">
                    <span class="label">Falls ja, wann und wo:</span>
                    <div class="input-line"></div>
                </div>
            </div>
        </div>

        <!-- 5. Behandlungsziele -->
        <div class="section">
            <div class="section-title">5. Behandlungsziele</div>
            
            <div class="form-group">
                <span class="label">Was möchten Sie durch die Behandlung erreichen?</span>
                <div class="input-box" style="height: 80px;"></div>
            </div>

            <div class="form-group">
                <span class="label">Haben Sie Bedenken oder Ängste bezüglich der Behandlung?</span>
                <div class="input-box"></div>
            </div>
        </div>

        <!-- 6. Einverständniserklärung -->
        <div class="section">
            <div class="section-title">6. Einverständniserklärung</div>
            
            <div class="checkbox-item" style="margin-bottom: 10px; min-width: 100%;">
                <div class="checkbox"></div> 
                Ich bin über die EMS Beckenboden Therapie aufgeklärt worden und stimme der Behandlung zu.
            </div>
            
            <div class="checkbox-item" style="margin-bottom: 10px; min-width: 100%;">
                <div class="checkbox"></div> 
                Ich bin damit einverstanden, dass meine Daten zur Behandlungsplanung und -dokumentation verwendet werden.
            </div>
            
            <div class="checkbox-item" style="margin-bottom: 10px; min-width: 100%;">
                <div class="checkbox"></div> 
                Ich wurde über die Datenschutzbestimmungen informiert und stimme diesen zu.
            </div>
        </div>

        <!-- Unterschrift -->
        <div class="signature-area">
            <div class="signature-box">
                <div class="signature-line"></div>
                <div>Datum, Unterschrift Patient/in</div>
            </div>
            <div class="signature-box">
                <div class="signature-line"></div>
                <div>Datum, Unterschrift Therapeutin</div>
            </div>
        </div>

        <!-- Therapeuten-Bereich -->
        <div class="therapist-section page-break">
            <div class="section-title">Für Therapeuten</div>
            
            <div class="form-group">
                <span class="label">Befund:</span>
                <div class="input-box" style="height: 80px;"></div>
            </div>

            <div class="form-group">
                <span class="label">Behandlungsplan:</span>
                <div class="input-box" style="height: 80px;"></div>
            </div>

            <div class="form-group">
                <span class="label">Anmerkungen:</span>
                <div class="input-box" style="height: 80px;"></div>
            </div>
        </div>
    </div>
</body>
</html>
        `;

    await page.setContent(htmlContent, { waitUntil: "networkidle0" });

    // Sicherstellen, dass das public-Verzeichnis existiert
    const publicDir = join(__dirname, "..", "public");
    if (!existsSync(publicDir)) {
      mkdirSync(publicDir, { recursive: true });
    }

    // PDF generieren
    const pdfPath = join(publicDir, "anamnesebogen.pdf");
    await page.pdf({
      path: pdfPath,
      format: "A4",
      margin: {
        top: "1.5cm",
        right: "1.5cm",
        bottom: "1.5cm",
        left: "1.5cm",
      },
      printBackground: true,
      preferCSSPageSize: true,
    });

    console.log("✅ PDF erfolgreich generiert:", pdfPath);
  } catch (error) {
    console.error("❌ Fehler bei der PDF-Generierung:", error);
    throw error;
  } finally {
    await browser.close();
  }
}

// Skript ausführen
generateAnamnesePDF()
  .then(() => {
    console.log("🎉 PDF-Generierung abgeschlossen!");
    process.exit(0);
  })
  .catch((error) => {
    console.error("💥 PDF-Generierung fehlgeschlagen:", error);
    process.exit(1);
  });
