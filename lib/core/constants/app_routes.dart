abstract final class AppRoutes {
  static const home = '/';
  static const toolWorkspace = '/tool';

  // Explicit feature routes (wired as phases land).
  static const wordToPdf = '/convert/word-to-pdf';
  static const pdfToImages = '/convert/pdf-to-images';
  static const imagesToPdf = '/convert/images-to-pdf';
  static const mergePdf = '/pdf/merge';
  static const splitPdf = '/pdf/split';
  static const extractPages = '/pdf/extract';
  static const compressPdf = '/pdf/compress';
  static const rotatePdf = '/pdf/rotate';
  static const watermark = '/pdf/watermark';
  static const protectPdf = '/security/protect';
  static const unlockPdf = '/security/unlock';
  static const metadata = '/pdf/metadata';
}
