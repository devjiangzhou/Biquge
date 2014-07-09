//
//  JZLabel.h
//  Biquge
//
//  Created by thx01 on 13-10-23.
//  Copyright (c) 2013年 JZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

////////////////////////////////////////////////////////////////////////////
// MARK: -
// MARK: NS(Mutable)AttributedString Additions
/////////////////////////////////////////////////////////////////////////////

@interface NSAttributedString (JZConstructors)
+(id)attributedStringWithString:(NSString*)string;
+(id)attributedStringWithAttributedString:(NSAttributedString*)attrStr;
@end

@interface NSMutableAttributedString (JZStyleModifiers)
-(void)setFont:(UIFont*)font;
-(void)setFont:(UIFont*)font range:(NSRange)range;
-(void)setFontName:(NSString*)fontName size:(CGFloat)size;
-(void)setFontName:(NSString*)fontName size:(CGFloat)size range:(NSRange)range;
-(void)setFontFamily:(NSString*)fontFamily size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic range:(NSRange)range;

-(void)setTextColor:(UIColor*)color;
-(void)setTextColor:(UIColor*)color range:(NSRange)range;

-(void)setTextAlignment:(CTTextAlignment)alignment multipleLine:(BOOL)multiple lineBreakMode:(CTLineBreakMode)lineBreakMode;
-(void)setTextAlignment:(CTTextAlignment)alignment  multipleLine:(BOOL)multiple lineBreakMode:(CTLineBreakMode)lineBreakMode range:(NSRange)range;

-(void)setKerning:(int)value;
-(void)setLeading:(CGFloat)value;
@end

@interface JZLabel : UILabel
{
   	NSMutableAttributedString* _attributedText; //!< Internally mutable, but externally immutable copy access only
	CGFloat						width;
}
@property(nonatomic, copy) NSAttributedString* attributedText; //!< Use this instead of the "text" property inherited from UILabel to set and get text
@property (nonatomic, assign)		CGFloat				 width;
-(void)resetAttributedText; //!< rebuild the attributedString based on UILabel's text/font/color/alignment/... properties
@end
