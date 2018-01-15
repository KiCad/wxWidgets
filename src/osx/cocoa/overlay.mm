/////////////////////////////////////////////////////////////////////////////
// Name:        src/osx/cocoa/overlay.mm
// Purpose:     common wxOverlay code
// Author:      Stefan Csomor
// Modified by:
// Created:     2006-10-20
// Copyright:   (c) wxWidgets team
// Licence:     wxWindows licence
/////////////////////////////////////////////////////////////////////////////

// ============================================================================
// declarations
// ============================================================================

// ----------------------------------------------------------------------------
// headers
// ----------------------------------------------------------------------------

// For compilers that support precompilation, includes "wx.h".
#include "wx/wxprec.h"

#ifdef __BORLANDC__
    #pragma hdrstop
#endif

#include "wx/overlay.h"

#ifndef WX_PRECOMP
    #include "wx/dcclient.h"
#endif

#include "wx/dcgraph.h"

#include "wx/private/overlay.h"

#ifdef wxHAS_NATIVE_OVERLAY
#import <Foundation/NSGeometry.h>

// ============================================================================
// implementation
// ============================================================================

wxOverlayImpl::wxOverlayImpl()
{
    m_window = NULL ;
    m_overlayWindow = NULL ;
}

wxOverlayImpl::~wxOverlayImpl()
{
    Reset();
}

bool wxOverlayImpl::IsOk()
{
    return m_overlayWindow != NULL ;
}

void wxOverlayImpl::CreateOverlayWindow()
{
}

void wxOverlayImpl::Init( wxDC* dc, int x , int y , int width , int height )
{
    wxASSERT_MSG( !IsOk() , _("You cannot Init an overlay twice") );

    m_window = dc->GetWindow();
	m_overlayWindow = m_window->MacGetTopLevelWindowRef();
	
	NSRect box = [m_overlayWindow frame];
	box.origin.x = 0;
	box.origin.y = 0;
	
	if( [m_overlayWindow isVisible] ) 	
	{
		[m_overlayWindow discardCachedImage];
		[m_overlayWindow cacheImageInRect:box];
	}
}

void wxOverlayImpl::BeginDrawing( wxDC* dc)
{
}

void wxOverlayImpl::EndDrawing( wxDC* dc)
{
}

void wxOverlayImpl::Clear( wxDC* WXUNUSED(dc) )
{
    wxASSERT_MSG( IsOk() , _("You cannot Clear an overlay that is not inited") );
    
	if( [m_overlayWindow isVisible] ) 
	{
		[m_overlayWindow restoreCachedImage];
//		[m_overlayWindow flushWindow]; 
	}
}

void wxOverlayImpl::Reset()
{
    // todo : don't dispose, only hide and reposition on next run
    if (m_overlayWindow &&  [m_overlayWindow isVisible])
    {
		NSRect box = [m_overlayWindow frame];
		box.origin.x = 0;
		box.origin.y = 0;
		
		[m_overlayWindow discardCachedImage];
		[m_overlayWindow cacheImageInRect:box];
    }
}

#endif // wxHAS_NATIVE_OVERLAY
