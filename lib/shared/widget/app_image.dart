import 'dart:convert';

import 'package:emer_app/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    required this.url,
    this.height,
    this.width,
    this.color,
    this.icon,
    this.fit,
    this.isDefaultColor,
    this.base64,
    this.isShowPlaceholder = true,
    this.isSvgAsset,
    super.key,
  });

  final String url;
  final double? height;
  final double? width;
  final Color? color;
  final IconData? icon;
  final BoxFit? fit;
  final bool? isDefaultColor;
  final bool? isShowPlaceholder;
  final String? base64;
  final bool? isSvgAsset;

  @override
  Widget build(BuildContext context) {
    if (url.contains('.png') || url.contains('.jpg')) {
      precacheImage(NetworkImage(url), context);
    }

    if (isSvgAsset ?? false) {
      return SvgPicture.asset(
        url,
        fit: fit ?? BoxFit.contain,
        height: height,
        width: width,
        colorFilter: isDefaultColor ?? false
            ? null
            : ColorFilter.mode(
                color ?? context.theme.primaryColor,
                BlendMode.srcIn,
              ),
        placeholderBuilder: isShowPlaceholder ?? false
            ? (context) => Icon(
                  icon ?? Icons.image,
                  color: color ?? context.theme.primaryColor,
                )
            : null,
      );
    }

    if (base64 != null) {
      return SizedBox(
        height: height,
        width: width,
        child: Image.memory(
          base64Decode(base64!),
          color: isDefaultColor ?? false
              ? null
              : (color ?? context.theme.primaryColor),
          fit: BoxFit.cover,
          height: height,
          width: width,
          errorBuilder: (
            context,
            exception,
            stackTrace,
          ) {
            return Icon(
              icon ?? Icons.image,
              color: color ?? context.theme.primaryColor,
            );
          },
        ),
      );
    }

    return SizedBox(
      height: height,
      width: width,
      child: (url.contains('.png') || url.contains('.jpg'))
          ? Image.network(
              url,
              color: isDefaultColor ?? false
                  ? null
                  : (color ?? context.theme.primaryColor),
              fit: BoxFit.cover,
              height: height,
              width: width,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (
                context,
                exception,
                stackTrace,
              ) {
                return Icon(
                  icon ?? Icons.question_mark,
                  color: color ?? context.theme.primaryColor,
                );
              },
            )
          : SvgPicture.network(
              url,
              fit: fit ?? BoxFit.contain,
              height: height,
              width: width,
              colorFilter: isDefaultColor ?? false
                  ? null
                  : ColorFilter.mode(
                      color ?? context.theme.primaryColor,
                      BlendMode.srcIn,
                    ),
              placeholderBuilder: isShowPlaceholder ?? false
                  ? (context) => Icon(
                        icon ?? Icons.image,
                        color: color ?? context.theme.primaryColor,
                      )
                  : null,
            ),
    );
  }
}
