# 📱 GUÍA PARA PUBLICAR FOOTBALL IMPOSTOR

## ✅ ANDROID - GOOGLE PLAY STORE

### 1️⃣ Archivo Generado
Tu **AAB (Android App Bundle)** está en:
```
C:\Users\morga\Documents\IMPOSTOR\build\app\outputs\bundle\release\app-release.aab
```

### 2️⃣ Subir a Google Play Console

1. **Accede a Google Play Console**
   - Ve a: https://play.google.com/console
   - Inicia sesión con tu cuenta de desarrollador de Google

2. **Crear Nueva Aplicación** (si es primera vez)
   - Click en "Crear aplicación"
   - Nombre: **Football Impostor**
   - Idioma predeterminado: **Español (España)**
   - Tipo: **Aplicación o juego**
   - Categoría: **Juego - Preguntas**

3. **Subir el AAB**
   - En el menú lateral: **Producción** → **Crear nueva versión**
   - Click en "**Cargar**" y selecciona: `app-release.aab`
   - Asigna un nombre a la versión: **1.0.0 (1)**

4. **Completar Ficha de la Tienda**
   
   **Descripción corta** (80 caracteres):
   ```
   ¿Quién es el impostor? Adivina al jugador secreto entre tus amigos
   ```
   
   **Descripción completa** (4000 caracteres):
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

   • Pack La Liga: Accede a jugadores españoles
   • Pack Premier League: Jugadores de la liga inglesa
   • Pack Serie A: Estrellas italianas
   • Pack Bundesliga: Cracks alemanes
   • Pack Ligue 1: Jugadores franceses
   • Premium Total: Todos los packs incluidos

   📊 CARACTERÍSTICAS TÉCNICAS:

   • Interfaz intuitiva y elegante
   • Diseño moderno en verde oscuro
   • Animaciones fluidas
   • Sonidos envolventes
   • Optimizado para todos los dispositivos

   🎮 PERFECTA PARA CUALQUIER OCASIÓN:

   Ya sea en una fiesta, en casa con amigos, o en cualquier reunión social, 
   Football Impostor es el juego perfecto para poner a prueba tu conocimiento 
   del fútbol y tus habilidades de deducción.

   ¿Podrás descubrir al impostor antes de que sea demasiado tarde?

   ⬇️ ¡Descarga ahora y comienza a jugar!
   ```

5. **Capturas de Pantalla**
   - Sube al menos 2 capturas de pantalla (1080x1920 o 16:9)
   - Gráfico de características: 1024x500 px
   - Icono: 512x512 px (ya configurado en `assets/hector_icon.jpg`)

6. **Clasificación de Contenido**
   - Completa el cuestionario
   - Categoría: **PEGI 3** (apto para todos)
   - No contiene violencia, lenguaje ofensivo, etc.

7. **Privacidad y Datos**
   - Política de privacidad: (necesitas crear una URL)
   - Permisos: Internet (para anuncios)

8. **Precios y Distribución**
   - Gratis con compras integradas
   - Países: Todos (o selecciona específicos)

9. **Enviar para Revisión**
   - Click en "**Enviar para revisión**"
   - Tiempo de revisión: 1-7 días

---

## 🍎 iOS - APP STORE

### 1️⃣ Requisitos Previos

**IMPORTANTE**: Para publicar en iOS necesitas:
- Una **Mac** (macOS Monterey o superior)
- **Xcode 15+** instalado
- **Cuenta de Apple Developer** ($99/año)
- Certificados y perfiles de aprovisionamiento

### 2️⃣ Preparar el Proyecto en Xcode

**Desde tu Mac**, abre el proyecto:

```bash
cd /ruta/a/IMPOSTOR
open ios/Runner.xcworkspace
```

### 3️⃣ Configurar en Xcode

1. **Selecciona el proyecto "Runner"** en el navegador izquierdo
2. En la pestaña **General**:
   - **Display Name**: Football Impostor
   - **Bundle Identifier**: com.footballimpostor.app
   - **Version**: 1.0.0
   - **Build**: 1
   - **Deployment Target**: iOS 13.0

3. En **Signing & Capabilities**:
   - Marca "**Automatically manage signing**"
   - Selecciona tu **Team** (cuenta de desarrollador)

### 4️⃣ Generar el IPA

Desde el terminal de tu Mac:

```bash
cd /ruta/a/IMPOSTOR
flutter build ipa --release
```

Esto generará el archivo en:
```
build/ios/ipa/football_impostor.ipa
```

### 5️⃣ Subir a App Store Connect

**Opción A: Usando Xcode**

1. En Xcode, ve a **Product** → **Archive**
2. Espera a que termine el archive
3. En la ventana **Organizer**, selecciona el archive
4. Click en "**Distribute App**"
5. Selecciona "**App Store Connect**"
6. Sigue el asistente hasta "**Upload**"

**Opción B: Usando Transporter**

1. Descarga **Transporter** desde la Mac App Store
2. Abre Transporter
3. Arrastra el archivo `.ipa` a la ventana
4. Click en "**Deliver**"

### 6️⃣ Configurar en App Store Connect

1. **Accede a App Store Connect**
   - Ve a: https://appstoreconnect.apple.com
   - Inicia sesión con tu cuenta de desarrollador

2. **Crear Nueva App**
   - Click en "**My Apps**" → "**+**" → "**New App**"
   - Platforms: **iOS**
   - Name: **Football Impostor**
   - Primary Language: **Spanish**
   - Bundle ID: `com.footballimpostor.app`
   - SKU: `football-impostor-001`

3. **Completar Información de la App**

   **Nombre**: Football Impostor
   
   **Subtítulo** (30 caracteres):
   ```
   Adivina el jugador impostor
   ```
   
   **Palabras clave** (100 caracteres):
   ```
   futbol,impostor,juego,amigos,social,adivina,jugador,partido,torneo,liga,deporte
   ```
   
   **Descripción**:
   (Usa la misma descripción completa de Android)
   
   **URL promocional**: (tu sitio web, si tienes)
   
   **URL de soporte**: (tu email o sitio de soporte)

4. **Capturas de Pantalla**
   - iPhone 6.7": 1290 x 2796 px (obligatorio)
   - iPhone 6.5": 1242 x 2688 px (obligatorio)
   - iPad Pro 12.9": 2048 x 2732 px (recomendado)

5. **Información General**
   - **Categoría primaria**: Juegos > Preguntas
   - **Categoría secundaria**: Juegos > Deportes
   - **Clasificación de edad**: 4+

6. **Precios y Disponibilidad**
   - Precio: **Gratis**
   - Disponibilidad: **Todos los países**

7. **Compilación (Build)**
   - En la sección "**Build**", click en "**+**"
   - Selecciona la compilación que subiste (1.0.0 (1))

8. **Enviar para Revisión**
   - Click en "**Add for Review**"
   - Luego en "**Submit for Review**"
   - Tiempo de revisión: 1-3 días

---

## 🎯 CHECKLIST FINAL

### Android ✅
- [x] AAB generado: `app-release.aab`
- [x] Keystore guardado: `upload-keystore.jks`
- [x] Contraseñas guardadas: `key.properties`
- [x] Version: 1.0.0+1
- [x] AdMob configurado
- [ ] Capturas de pantalla preparadas
- [ ] Cuenta Google Play Console lista
- [ ] Política de privacidad creada

### iOS ⏳
- [ ] Acceso a Mac
- [ ] Xcode instalado
- [ ] Cuenta Apple Developer activa
- [ ] Certificados configurados
- [ ] IPA generado
- [ ] App Store Connect configurado
- [ ] Capturas de pantalla iOS preparadas

---

## 📞 SOPORTE

Si tienes problemas durante el proceso:

1. **Errores de compilación**: Ejecuta `flutter doctor`
2. **Problemas de firma Android**: Verifica `key.properties`
3. **Problemas iOS**: Asegúrate de tener los certificados correctos
4. **Rechazo en revisión**: Lee las guías de cada tienda

---

## 🚀 ¡ÉXITO!

Tu app está lista para publicarse. Sigue los pasos cuidadosamente y en unos días estará disponible en las tiendas.

**Archivos importantes a guardar**:
- `upload-keystore.jks` - ⚠️ NO LO PIERDAS (necesario para futuras actualizaciones)
- `key.properties` - Contraseñas del keystore
- Los certificados de iOS

¡Buena suerte con tu lanzamiento! 🎉

