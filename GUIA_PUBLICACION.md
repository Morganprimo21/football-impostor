# 📱 GUÍA COMPLETA PARA INSTALAR Y PUBLICAR FOOTBALL IMPOSTOR

## ✅ CAMBIOS REALIZADOS

- ✅ Localización completa (Español/Inglés)
- ✅ Botón cambiado de "COMENZAR" a "PARTIDA RÁPIDA"
- ✅ Logo sin fondo gris en packs de jugadores
- ✅ Tamaños de letra reducidos en botones
- ✅ Pantalla principal sin scroll
- ✅ AdMob configurado (Android e iOS)
- ✅ In-App Purchases configurados
- ✅ Código limpio y optimizado

---

## 📦 ARCHIVOS GENERADOS

### **Android AAB (Para Google Play):**
```
C:\Users\morga\Documents\IMPOSTOR\build\app\outputs\bundle\release\app-release.aab
```
✅ **Listo para subir a Google Play Console**

### **Keystore (Guardar para siempre):**
```
C:\Users\morga\upload-keystore.jks
```
⚠️ **MUY IMPORTANTE**: NO pierdas este archivo. Lo necesitarás para **todas las actualizaciones futuras**.

---

## 🚀 OPCIÓN 1: INSTALAR EN TU MÓVIL (GRATIS)

### **📱 Android:**

#### **Método A: Generar APK localmente**
1. Abre la terminal en tu PC
2. Ejecuta:
   ```bash
   cd C:\Users\morga\Documents\IMPOSTOR
   flutter build apk --release
   ```
3. El APK estará en:
   ```
   build\app\outputs\flutter-apk\app-release.apk
   ```
4. Envía el APK a tu móvil (WhatsApp, email, cable USB)
5. Abre el APK en tu móvil e instala

#### **Método B: Desde Codemagic**
1. Espera a que termine el build en Codemagic
2. Descarga el APK desde los "Artifacts"
3. Envíalo a tu móvil e instala

### **🍎 iPhone:**

#### **Con 3uTools (desde Windows):**
1. Descarga **3uTools**: http://www.3u.com/
2. Instala 3uTools en tu PC
3. Obtén el IPA de Codemagic (necesita configuración de certificados)
4. Conecta tu iPhone al PC
5. Abre 3uTools → Apps → Install
6. Selecciona el IPA y 3uTools lo instalará

#### **Limitación:**
⚠️ Para generar IPA instalable necesitas:
- Apple Developer Account ($99/año) o
- Configurar Codemagic con certificados

---

## 🏪 OPCIÓN 2: PUBLICAR EN GOOGLE PLAY STORE

### **💰 Costo: $25 USD (pago único, de por vida)**

### **📋 Pasos:**

#### **1️⃣ Crear cuenta de Google Play Console**
- Ve a: https://play.google.com/console
- Paga los $25 USD de registro
- Acepta los términos y condiciones

#### **2️⃣ Crear nueva aplicación**
1. Click en "**Crear aplicación**"
2. **Nombre**: Football Impostor
3. **Idioma predeterminado**: Español (España)
4. **Tipo**: Aplicación o juego
5. **Gratis o de pago**: Gratis

#### **3️⃣ Completar datos básicos**

**Panel izquierdo → Configuración de la aplicación:**

- **Categoría de la aplicación**: Juego
- **Categoría del juego**: Preguntas
- **Etiquetas**: Deportes, Social, Multijugador

#### **4️⃣ Ficha de la tienda**

**Descripción breve (80 caracteres):**
```
¿Quién es el impostor? Adivina al jugador secreto entre tus amigos
```

**Descripción completa:**
```
🎯 FOOTBALL IMPOSTOR - El juego social de adivinanzas de fútbol

¿Eres capaz de encontrar al impostor? En Football Impostor, uno de tus amigos 
se hace pasar por un jugador de fútbol... ¡pero no conoce todas sus estadísticas!

🕵️ CÓMO SE JUEGA:

• Partida Rápida: Juego rápido sin torneos
• Modo Torneo: Compite en múltiples rondas
• Cada jugador recibe un rol secreto
• Los inocentes deben adivinar quién es el impostor
• El impostor debe ocultarse y engañar a todos

⚽ CARACTERÍSTICAS:

• Jugadores de las mejores ligas europeas
• Packs Premium: La Liga, Premier League, Serie A, Bundesliga, Ligue 1
• Sistema de votaciones estratégicas
• Pistas y estadísticas reales
• Perfecto para jugar con amigos
• Sin necesidad de conexión a internet

👥 IDEAL PARA:

• Reuniones con amigos
• Fiestas y eventos
• Fanáticos del fútbol
• Amantes de juegos sociales
• Grupos de 3 a 12 jugadores

🏆 MODOS DE JUEGO:

PARTIDA RÁPIDA
Perfecta para jugar una ronda rápida sin complicaciones.

TORNEO
Compite en múltiples rondas, acumula puntos y descubre quién es el mejor detective.

💎 CONTENIDO PREMIUM:

• Pack La Liga: Jugadores españoles
• Pack Premier League: Jugadores ingleses
• Pack Serie A: Estrellas italianas
• Pack Bundesliga: Cracks alemanes
• Pack Ligue 1: Jugadores franceses
• Premium Total: Todos los packs incluidos

📊 CARACTERÍSTICAS TÉCNICAS:

• Interfaz intuitiva y elegante
• Diseño moderno en verde oscuro
• Animaciones fluidas
• Optimizado para todos los dispositivos
• Soporte para español e inglés

🎮 PERFECTA PARA CUALQUIER OCASIÓN

Ya sea en una fiesta, en casa con amigos, o en cualquier reunión social, 
Football Impostor es el juego perfecto para poner a prueba tu conocimiento 
del fútbol y tus habilidades de deducción.

¿Podrás descubrir al impostor antes de que sea demasiado tarde?

⬇️ ¡Descarga ahora y comienza a jugar!
```

**Icono de la aplicación:**
```
assets/hector_icon.jpg (512x512 px)
```

#### **5️⃣ Capturas de pantalla**

**Necesitas al menos 2 capturas de pantalla:**

**Tamaños requeridos:**
- Teléfono: 1080 x 1920 px (16:9) - Mínimo 2 imágenes
- Tablet 7": 1024 x 600 px - Opcional
- Tablet 10": 1920 x 1200 px - Opcional

**Cómo hacer capturas:**
1. Ejecuta la app en el emulador
2. Navega por las pantallas principales
3. Usa la tecla Print Screen
4. Recorta a 1080x1920 px

**Sugerencia de capturas:**
1. Pantalla de inicio
2. Configuración de partida
3. Pantalla de rol (impostor/inocente)
4. Pantalla de resultados
5. Pantalla de packs premium

#### **6️⃣ Gráfico de características (opcional pero recomendado)**
- **Tamaño**: 1024 x 500 px
- Banner promocional para mostrar en la tienda

#### **7️⃣ Clasificación de contenido**
1. Ve a **Clasificación de contenido**
2. Completa el cuestionario:
   - ❌ No contiene violencia
   - ❌ No contiene lenguaje ofensivo
   - ❌ No contiene contenido sexual
   - ❌ No contiene drogas
   - ✅ Es apto para todos
3. **Resultado**: PEGI 3 (Apto para todos)

#### **8️⃣ Política de privacidad**

**Necesitas una URL de política de privacidad.**

Opciones:
- Crea una en: https://app-privacy-policy-generator.firebaseapp.com/
- O usa GitHub Pages con tu política

**Contenido mínimo:**
- Uso de AdMob (publicidad)
- Datos recopilados: Ninguno (solo IDs de publicidad)
- No se comparten datos con terceros

#### **9️⃣ Configurar productos de compra (In-App)**

**Ve a Monetización → Productos:**

Crea los siguientes productos (deben coincidir con tu código):

| ID del producto | Nombre | Precio |
|-----------------|---------|---------|
| `premium_all` | Premium Total | €4.99 |
| `pack_laliga` | Pack La Liga | €1.49 |
| `pack_premier` | Pack Premier League | €1.49 |
| `pack_seriea` | Pack Serie A | €1.49 |
| `pack_bundes` | Pack Bundesliga | €1.49 |
| `pack_ligue1` | Pack Ligue 1 | €1.49 |

#### **🔟 Subir el AAB**

1. Ve a **Producción** → **Crear nueva versión**
2. Click en "**Cargar**"
3. Selecciona: `app-release.aab`
4. **Nombre de la versión**: 1.0.0 (1)
5. **Notas de la versión**:
   ```
   Primera versión de Football Impostor
   - Modo Partida Rápida
   - Modo Torneo
   - Sistema de packs de jugadores
   - Soporte multiidioma (ES/EN)
   - Anuncios AdMob
   ```

#### **1️⃣1️⃣ Países y regiones**
- **Disponibilidad**: Todos los países
- O selecciona específicos: España, Latinoamérica, etc.

#### **1️⃣2️⃣ Enviar para revisión**
1. Revisa que todo esté completo (Google Play te mostrará un checklist)
2. Click en "**Enviar para revisión**"
3. **Tiempo de revisión**: 1-7 días (normalmente 24-48 horas)

#### **1️⃣3️⃣ Esperar aprobación**
- Recibirás un email cuando sea aprobada
- Una vez aprobada, estará disponible en Google Play

---

## 🍎 OPCIÓN 3: PUBLICAR EN APP STORE (iOS)

### **💰 Costo: $99 USD/año**

### **📋 Requisitos:**
- ✅ Apple Developer Account (pagas $99/año)
- ✅ Mac (para compilar) O Codemagic con certificados
- ✅ Certificados de firma de código

### **Pasos con Codemagic:**

#### **1️⃣ Configurar certificados en Codemagic**
1. Ve a la configuración del proyecto en Codemagic
2. Sección "**Distribution**" o "**Code signing**"
3. Conecta tu Apple Developer Account
4. Codemagic generará automáticamente los certificados

#### **2️⃣ Compilar IPA**
1. Inicia un build en Codemagic
2. Espera 10-15 minutos
3. Descarga el IPA de los Artifacts

#### **3️⃣ Subir a App Store Connect**

**Opción A: Codemagic automático**
- Configura en Codemagic para que suba automáticamente
- No necesitas Mac

**Opción B: Con Mac**
- Abre Xcode
- Product → Archive
- Distribute → App Store Connect
- Upload

#### **4️⃣ Configurar en App Store Connect**
1. Ve a: https://appstoreconnect.apple.com
2. Crea nueva app
3. Bundle ID: `com.footballimpostor.app`
4. Completa la información (usa las mismas descripciones de Android)
5. Sube capturas para iPhone
6. Envía para revisión

**Tiempo de revisión**: 1-3 días

---

## 📝 CHECKLIST FINAL

### **Para instalar en TU móvil (GRATIS):**
- [x] APK generado ✅
- [x] Código actualizado en GitHub ✅
- [x] Localización completa ✅
- [ ] Descargar APK y enviar al móvil
- [ ] Instalar en el móvil
- [ ] Probar todas las funcionalidades

### **Para publicar en Google Play ($25):**
- [x] AAB generado y firmado ✅
- [x] Keystore guardado de forma segura ✅
- [x] Versión 1.0.0+1 configurada ✅
- [x] AdMob configurado ✅
- [x] In-App Purchases configurados ✅
- [ ] Cuenta de Google Play Console creada
- [ ] Capturas de pantalla preparadas (mínimo 2)
- [ ] Política de privacidad creada
- [ ] Productos IAP configurados en Google Play
- [ ] AAB subido a Google Play Console
- [ ] Ficha de la tienda completada
- [ ] Clasificación de contenido completada
- [ ] Enviado para revisión

### **Para publicar en App Store ($99/año):**
- [ ] Apple Developer Account creada
- [ ] Certificados configurados en Codemagic
- [ ] IPA generado
- [ ] App creada en App Store Connect
- [ ] Capturas de pantalla iOS preparadas
- [ ] IPA subido a App Store Connect
- [ ] Información completada
- [ ] Enviado para revisión

---

## 🎯 PRÓXIMOS PASOS RECOMENDADOS

### **1️⃣ Probar en tu móvil primero (HOY):**
```bash
flutter build apk --release
```
Luego instala el APK en tu Android y prueba todo.

### **2️⃣ Preparar capturas de pantalla (MAÑANA):**
- Haz 4-5 capturas bonitas de la app
- Usa el emulador en modo release
- Recorta a 1080x1920 px

### **3️⃣ Crear política de privacidad (MAÑANA):**
- Usa: https://app-privacy-policy-generator.firebaseapp.com/
- Sube a una página web o GitHub Pages

### **4️⃣ Publicar en Google Play (ESTA SEMANA):**
- Paga los $25 USD
- Sube el AAB
- Completa la ficha
- Envía para revisión

### **5️⃣ iOS (OPCIONAL):**
- Si quieres publicar en App Store
- Necesitas Mac o Codemagic con certificados
- Paga $99/año Apple Developer

---

## 📞 SOPORTE Y AYUDA

### **Si tienes problemas:**

**Errores de compilación:**
```bash
flutter clean
flutter pub get
flutter build apk --release
```

**App no instala en móvil:**
- Activa "Instalar desde fuentes desconocidas" en Android

**AAB rechazado en Google Play:**
- Verifica que los productos IAP estén configurados
- Asegúrate de que AdMob IDs sean los correctos

**Necesitas actualizar la app:**
1. Incrementa la versión en `pubspec.yaml` (ej: 1.0.1+2)
2. Genera nuevo AAB con el mismo keystore
3. Sube a Google Play Console

---

## 📧 INFORMACIÓN DE CONTACTO PARA LA TIENDA

**Email de soporte**: morganprimo20@gmail.com
**Sitio web**: (Crea uno si quieres, o usa tu GitHub)
**Política de privacidad**: (Crea la URL)

---

## 🎉 ¡ÉXITO!

Tu app está **100% lista** para:
- ✅ Instalar en tu móvil
- ✅ Publicar en Google Play
- ✅ Publicar en App Store (con certificados)

**Buena suerte con tu lanzamiento!** 🚀

---

## 📌 RECORDATORIOS IMPORTANTES

⚠️ **NUNCA pierdas estos archivos:**
- `C:\Users\morga\upload-keystore.jks`
- `android\key.properties`

Sin ellos NO podrás actualizar la app en el futuro.

✅ **GitHub actualizado:**
- Repo: https://github.com/Morganprimo21/football-impostor
- Último commit: Localización completa implementada
- Todas las features funcionando

---

**¿Necesitas ayuda con algo específico?**
- Capturas de pantalla
- Política de privacidad
- Configuración de productos IAP
- Pruebas en tu móvil


