# 📱 GUÍA PARA PUBLICAR FOOTBALL IMPOSTOR

## ✅ PREPARACIÓN COMPLETADA

- ✅ Código limpiado
- ✅ Versión: 1.0.0+1
- ✅ AdMob configurado (Android + iOS)
- ✅ Compras In-App configuradas
- ✅ Iconos generados
- ✅ Sin errores de linter

---

# 🤖 ANDROID - GOOGLE PLAY STORE

## 1. CREAR KEYSTORE (Solo primera vez)

```powershell
keytool -genkey -v -keystore c:\Users\morga\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Te preguntará:
# - Contraseña del keystore (anótala, la necesitarás)
# - Nombre, organización, etc.
# - Contraseña de la key (puede ser la misma)
```

## 2. CONFIGURAR FIRMA

Crea `android/key.properties`:

```
storePassword=TU_CONTRASEÑA
keyPassword=TU_CONTRASEÑA
keyAlias=upload
storeFile=c:/Users/morga/upload-keystore.jks
```

## 3. GENERAR AAB

```powershell
flutter build appbundle --release
```

El archivo estará en:
```
build\app\outputs\bundle\release\app-release.aab
```

## 4. SUBIR A GOOGLE PLAY CONSOLE

1. Ve a https://play.google.com/console
2. Crear nueva app → "Football Impostor"
3. Completar ficha de la tienda:
   - Descripción corta y larga
   - Capturas de pantalla (mínimo 2)
   - Icono (512x512)
   - Gráfico destacado (1024x500)
4. Producción → Crear nueva versión
5. Subir `app-release.aab`
6. Enviar para revisión

---

# 🍎 iOS - APP STORE

## 1. CONFIGURAR EN XCODE

```powershell
cd ios
open Runner.xcworkspace
```

En Xcode:
1. Selecciona "Runner" (proyecto)
2. General → Signing & Capabilities
3. **Team**: Selecciona tu Apple Developer Account
4. **Bundle Identifier**: Verifica que sea único (ej: `com.tuempresa.footballimpostor`)
5. Marca **Automatically manage signing**

## 2. GENERAR IPA

```powershell
# Volver a la raíz del proyecto
cd ..

# Build para iOS
flutter build ipa
```

El archivo estará en:
```
build\ios\archive\Runner.xcarchive
```

## 3. SUBIR A APP STORE CONNECT

### Opción A: Desde Xcode
1. En Xcode: Product → Archive
2. Cuando termine: Window → Organizer
3. Selecciona el archive → Distribute App
4. App Store Connect → Upload
5. Sigue el asistente

### Opción B: Transporter App
1. Descarga Transporter de la App Store
2. Arrastra el `.ipa` a Transporter
3. Click "Deliver"

## 4. COMPLETAR EN APP STORE CONNECT

1. Ve a https://appstoreconnect.apple.com
2. Mis Apps → + → Nueva App
3. Nombre: "Football Impostor"
4. Completar información:
   - Capturas (mínimo 3)
   - Descripción
   - Palabras clave
   - Categoría: Juegos
5. Selecciona el build subido
6. Enviar para revisión

---

# 📋 ANTES DE ENVIAR

## Checklist Final

### Android
- [ ] Keystore creado y guardado en lugar seguro
- [ ] `key.properties` configurado
- [ ] AAB generado sin errores
- [ ] Probado en dispositivo real
- [ ] Capturas de pantalla tomadas
- [ ] Descripción escrita

### iOS
- [ ] Apple Developer Account activo ($99/año)
- [ ] Certificados configurados en Xcode
- [ ] Build generado sin errores
- [ ] Probado en dispositivo real
- [ ] Capturas de pantalla tomadas
- [ ] Descripción escrita

---

# 🎯 COMANDOS RÁPIDOS

```powershell
# Generar AAB para Android
flutter build appbundle --release

# Generar IPA para iOS
flutter build ipa

# Probar en release mode
flutter run --release

# Limpiar y rebuild
flutter clean
flutter pub get
flutter build appbundle --release
```

---

# ⏰ TIEMPOS DE REVISIÓN

- **Google Play**: 1-3 días
- **App Store**: 1-7 días

---

# 📞 SOPORTE

Si hay errores:
1. Revisa los logs en la consola
2. Verifica que todos los IDs de AdMob estén correctos
3. Asegúrate de tener las últimas versiones de Flutter y Xcode

```powershell
flutter doctor -v
```

