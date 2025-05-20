import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Clase para manejar los temas de la aplicación ORACLE
class AppThemes {
  // ==================== 1. PALETA DE COLORES AMPLIADA ====================
  // Colores base
  static const Color primaryBlack = Color(0xFF121212);
  static const Color deepBlack = Color(0xFF050505);
  static const Color primaryBlue = Color(0xFF2962FF);
  static const Color accentBlue = Color(0xFF448AFF);
  static const Color secondaryColor = Color(0xFF6200EA);
  static const Color tertiaryColor = Color(0xFFFF6D00);
  
  // Colores funcionales
  static const Color errorColor = Color(0xFFD50000);
  static const Color successColor = Color(0xFF00C853);
  static const Color warningColor = Color(0xFFFFD600);
  static const Color infoColor = Color(0xFF00B0FF);
  
  // Paleta extendida - Colores "neón" para acentos
  static const Color neonBlue = Color(0xFF00BFFF);
  static const Color neonPurple = Color(0xFFB000FF);
  static const Color neonPink = Color(0xFFFF00EA);
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color neonOrange = Color(0xFFFF7700);
  
  // Colores para fondos de tipo cristal con opacidad
  static Color glassBlack = Colors.black.withOpacity(0.7);
  static Color glassDeepBlue = primaryBlue.withOpacity(0.15);
  static Color glassBlue = primaryBlue.withOpacity(0.7);
  static Color glassPurple = secondaryColor.withOpacity(0.5);
  
  // ==================== 2. EFECTOS VISUALES AVANZADOS ====================
  // Método para crear un efecto de cristal/vidrio para los widgets con mayor personalización
  static BoxDecoration glassEffect({
    Color color = Colors.black,
    double opacity = 0.7,
    double borderRadius = 16,
    double borderWidth = 1.5,
    Color borderColor = Colors.white30,
    List<BoxShadow>? customShadows,
  }) {
    return BoxDecoration(
      color: color.withOpacity(opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor,
        width: borderWidth,
      ),
      boxShadow: customShadows ?? [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          spreadRadius: 1,
          offset: const Offset(0, 5),
        ),
        BoxShadow(
          color: color == Colors.black 
              ? Colors.white.withOpacity(0.05) 
              : color.withOpacity(0.1),
          blurRadius: 5,
          spreadRadius: -1,
          offset: const Offset(0, -1),
        ),
      ],
    );
  }
  
  // Método mejorado para crear un efecto de borde brillante con personalización
  static BoxDecoration glowEffect({
    Color glowColor = primaryBlue,
    double borderRadius = 16,
    double spreadRadius = 1,
    double blurRadius = 15,
    bool animate = false,
    bool pulsate = false,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: glowColor.withOpacity(0.6),
          spreadRadius: spreadRadius,
          blurRadius: blurRadius,
        ),
        if (pulsate)
          BoxShadow(
            color: glowColor.withOpacity(0.3),
            spreadRadius: spreadRadius * 2,
            blurRadius: blurRadius * 1.5,
          ),
      ],
    );
  }
  
  // Método para crear fondos con gradientes avanzados
  static BoxDecoration gradientBackground({
    List<Color>? colors,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    double borderRadius = 0,
    bool applyOverlay = false,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: begin,
        end: end,
        colors: colors ?? [
          deepBlack,
          primaryBlack,
          Color.lerp(primaryBlack, primaryBlue.withOpacity(0.2), 0.5)!,
        ],
      ),
      borderRadius: BorderRadius.circular(borderRadius),
      image: applyOverlay ? const DecorationImage(
        image: AssetImage('assets/images/noise_texture.png'),
        opacity: 0.03,
        fit: BoxFit.cover,
      ) : null,
    );
  }
  
  // Método para crear fondos con cuadrícula (grid) para paneles
  static BoxDecoration gridBackground({
    Color gridColor = Colors.white12,
    double gridSpacing = 20,
    double gridLineWidth = 0.5,
    double borderRadius = 0,
  }) {
    return BoxDecoration(
      color: primaryBlack,
      borderRadius: BorderRadius.circular(borderRadius),
      backgroundBlendMode: BlendMode.overlay,
      image: DecorationImage(
        image: const AssetImage('assets/images/grid_pattern.png'),
        repeat: ImageRepeat.repeat,
        scale: gridSpacing / 10,
        opacity: 0.05,
      ),
    );
  }
  
  // ==================== 3. ESTILOS DETALLADOS DE COMPONENTES ====================
  // Tema oscuro principal con efectos visuales avanzados
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: primaryBlue,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
      error: errorColor,
      background: primaryBlack,
      surface: deepBlack,
      onBackground: Colors.white,
      onSurface: Colors.white,
      brightness: Brightness.dark,
    ),
    
    // Barra de estado y navegación del sistema
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: glassBlack,
      scrolledUnderElevation: 0.0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: primaryBlack,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    
    // Tarjetas optimizadas para mejor legibilidad
    cardTheme: CardTheme(
      color: glassBlack,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
    ),
    
    // Personalización avanzada de texto
    textTheme: Typography.whiteMountainView.copyWith(
      displayLarge: TextStyle(
        color: Colors.white.withOpacity(0.95),
        fontSize: 34,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        color: Colors.white.withOpacity(0.95),
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: Colors.white.withOpacity(0.9),
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Colors.white.withOpacity(0.9),
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: Colors.white.withOpacity(0.9),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: Colors.white.withOpacity(0.9),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 15,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: 14,
        height: 1.4,
      ),
      labelLarge: const TextStyle(
        color: primaryBlue,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
    
    // Botones con efectos visuales mejorados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return primaryBlue.withOpacity(0.8);
          }
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey.shade800;
          }
          return glassBlue;
        }),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        overlayColor: MaterialStateProperty.all(Colors.white10),
        shadowColor: MaterialStateProperty.all(primaryBlue.withOpacity(0.3)),
        elevation: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return 0;
          }
          return 2;
        }),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    ),
    
    // Botones de texto con efecto de hover
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.hovered)) {
            return neonBlue;
          }
          return primaryBlue;
        }),
        overlayColor: MaterialStateProperty.all(primaryBlue.withOpacity(0.05)),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ),
    
    // Botones con borde luminoso
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        side: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return BorderSide(color: primaryBlue.withOpacity(0.7), width: 2);
          }
          if (states.contains(MaterialState.hovered)) {
            return const BorderSide(color: neonBlue, width: 2);
          }
          return const BorderSide(color: primaryBlue, width: 2);
        }),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        overlayColor: MaterialStateProperty.all(primaryBlue.withOpacity(0.1)),
      ),
    ),
    
    // Iconos con efectos visuales
    iconTheme: IconThemeData(
      color: Colors.white.withOpacity(0.9),
      size: 24,
      opacity: 0.9,
    ),
    
    // Campos de texto con efectos visuales mejorados
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: glassBlack,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: errorColor, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      labelStyle: TextStyle(
        color: Colors.white.withOpacity(0.6),
        fontSize: 16,
      ),
      floatingLabelStyle: const TextStyle(
        color: primaryBlue,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: TextStyle(
        color: Colors.white.withOpacity(0.4),
        fontSize: 16,
      ),
      helperStyle: TextStyle(
        color: Colors.white.withOpacity(0.5),
        fontSize: 12,
      ),
      errorStyle: const TextStyle(
        color: errorColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      suffixIconColor: Colors.white.withOpacity(0.7),
      prefixIconColor: Colors.white.withOpacity(0.7),
    ),
    
    // Barra de navegación inferior con efecto de cristal
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: glassBlack,
      selectedItemColor: primaryBlue,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    
    // Tabs con efecto de selección mejorado
    tabBarTheme: TabBarTheme(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white54,
      indicator: BoxDecoration(
        color: primaryBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: primaryBlue.withOpacity(0.5),
          width: 1,
        ),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
    
    // ==================== 4. COMPONENTES ESPECIALIZADOS Y DETALLES ====================
    // Diálogos con efecto de cristal
    dialogTheme: DialogTheme(
      backgroundColor: glassBlack,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    
    // SnackBars flotantes con borde sutil
    snackBarTheme: SnackBarThemeData(
      backgroundColor: glassBlack,
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      elevation: 5,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      actionTextColor: neonBlue,
    ),
    
    // Indicadores de progreso con colores personalizados
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryBlue,
      linearTrackColor: Colors.white12,
      linearMinHeight: 8.0,
      circularTrackColor: Colors.white12,
      refreshBackgroundColor: Colors.white10,
    ),
    
    // Efecto de ondas en interacciones táctiles
    splashColor: primaryBlue.withOpacity(0.1),
    splashFactory: InkRipple.splashFactory,
    highlightColor: Colors.transparent,
    
    // Checkboxes y Radio buttons con estilo neón
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryBlue;
        }
        return Colors.white24;
      }),
      checkColor: MaterialStateProperty.all(Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1.5),
    ),
    
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return neonBlue;
        }
        return Colors.white24;
      }),
      splashRadius: 24,
    ),
    
    // Switches con estilo premium
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return neonBlue;
        }
        return Colors.white;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return neonBlue.withOpacity(0.4);
        }
        return Colors.white24;
      }),
      trackOutlineColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return neonBlue.withOpacity(0.1);
        }
        return Colors.transparent;
      }),
      splashRadius: 24,
    ),
    
    // Chips con diseño moderno
    chipTheme: ChipThemeData(
      backgroundColor: glassDeepBlue,
      disabledColor: Colors.grey.shade800.withOpacity(0.5),
      selectedColor: primaryBlue.withOpacity(0.2),
      secondarySelectedColor: primaryBlue.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      brightness: Brightness.dark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: primaryBlue.withOpacity(0.3), width: 1),
      ),
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withOpacity(0.2),
      elevation: 0,
      selectedShadowColor: primaryBlue.withOpacity(0.2),
      showCheckmark: true,
      checkmarkColor: neonBlue,
    ),
    
    // Divisores sutiles
    dividerTheme: DividerThemeData(
      color: Colors.white.withOpacity(0.1),
      thickness: 1,
      space: 32,
      indent: 16,
      endIndent: 16,
    ),
    
    // Barras de desplazamiento (scrollbar) personalizadas
    scrollbarTheme: ScrollbarThemeData(
      radius: const Radius.circular(8),
      thickness: MaterialStateProperty.all(6),
      thumbColor: MaterialStateProperty.all(primaryBlue.withOpacity(0.4)),
      trackColor: MaterialStateProperty.all(Colors.white.withOpacity(0.05)),
      thumbVisibility: MaterialStateProperty.all(true),
      interactive: true,
    ),
    
    // Sliders con diseño neón
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryBlue,
      inactiveTrackColor: Colors.white24,
      thumbColor: neonBlue,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      overlayColor: primaryBlue.withOpacity(0.2),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
      trackHeight: 4,
      valueIndicatorColor: glassBlack,
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      showValueIndicator: ShowValueIndicator.always,
    ),
    
    // Tooltip con efecto de cristal
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: glassBlack,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      preferBelow: true,
      triggerMode: TooltipTriggerMode.longPress,
    ),
    
    // Banners con mejor visibilidad
    bannerTheme: MaterialBannerThemeData(
      backgroundColor: glassBlack,
      contentTextStyle: TextStyle(
        color: Colors.white.withOpacity(0.9),
        fontSize: 14,
      ),
      padding: const EdgeInsets.all(16),
      leadingPadding: const EdgeInsets.only(right: 16),
    ),
  );
  
  // ==================== MÉTODOS UTILITARIOS ADICIONALES ====================
  // Colores adaptados al modo oscuro/claro
  static Color adaptiveColor(BuildContext context, {Color? light, Color? dark}) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark 
        ? (dark ?? Colors.white) 
        : (light ?? Colors.black);
  }
  
  // Generador de sombras personalizadas
  static List<BoxShadow> customShadows({
    Color shadowColor = Colors.black,
    double elevation = 4,
    bool inner = false,
    bool glow = false,
    Color? glowColor,
  }) {
    if (inner) {
      return [
        BoxShadow(
          color: shadowColor.withOpacity(0.2),
          blurRadius: elevation * 2,
          spreadRadius: -elevation / 2,
          offset: const Offset(0, 0),
        ),
      ];
    } else if (glow) {
      return [
        BoxShadow(
          color: (glowColor ?? primaryBlue).withOpacity(0.5),
          blurRadius: elevation * 3,
          spreadRadius: elevation / 3,
        ),
      ];
    } else {
      return [
        BoxShadow(
          color: shadowColor.withOpacity(0.2),
          blurRadius: elevation * 1.5,
          spreadRadius: elevation / 5,
          offset: Offset(0, elevation / 2),
        ),
      ];
    }
  }
  
  // Método para crear fondos con partículas/estrellas
  static BoxDecoration starfieldBackground({
    Color backgroundColor = deepBlack,
    double starDensity = 0.5,
    bool animated = false,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      image: DecorationImage(
        image: const AssetImage('assets/images/starfield.png'),
        opacity: starDensity,
        fit: BoxFit.cover,
      ),
    );
  }
}