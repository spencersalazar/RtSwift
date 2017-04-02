//
//  FastCircularBuffer.c
//  RtSwift
//
//  Created by Spencer Salazar on 4/1/17.
//  Copyright © 2017 Spencer Salazar. All rights reserved.
//

#include "FastCircularBuffer.h"
#include <stdlib.h>
#include <string.h>
#include <algorithm>

//-----------------------------------------------------------------------------
// name: FastCircularBuffer()
// desc: constructor
//-----------------------------------------------------------------------------
FastCircularBuffer::FastCircularBuffer()
{
    m_data = NULL;
    m_data_width = m_read_offset = m_write_offset = m_max_elem = 0;
}




//-----------------------------------------------------------------------------
// name: ~FastCircularBuffer()
// desc: destructor
//-----------------------------------------------------------------------------
FastCircularBuffer::~FastCircularBuffer()
{
    this->cleanup();
}




//-----------------------------------------------------------------------------
// name: initialize()
// desc: initialize
//-----------------------------------------------------------------------------
bool FastCircularBuffer::initialize( unsigned int num_elem, unsigned int width )
{
    // cleanup
    cleanup();
    
    // allocate
    m_data = (unsigned char *)malloc( num_elem * width );
    if( !m_data )
        return false;
    
    m_data_width = width;
    m_read_offset = 0;
    m_write_offset = 0;
    m_max_elem = num_elem;
    
    return true;
}




//-----------------------------------------------------------------------------
// name: cleanup()
// desc: cleanup
//-----------------------------------------------------------------------------
void FastCircularBuffer::cleanup()
{
    if( !m_data )
        return;
    
    free( m_data );
    
    m_data = NULL;
    m_data_width = m_read_offset = m_write_offset = m_max_elem = 0;
}




//-----------------------------------------------------------------------------
// name: put()
// desc: put
//-----------------------------------------------------------------------------
unsigned int FastCircularBuffer::put( void * _data, unsigned int num_elem )
{
    unsigned char * data = (unsigned char *)_data;
    
    // TODO: overflow checking
    if(!(num_elem < ((m_read_offset > m_write_offset) ?
                     (m_read_offset - m_write_offset) :
                     (m_max_elem - m_write_offset + m_read_offset))))
    {
        return 0;
    }
    
    unsigned int elems_before_end = std::min(num_elem, m_max_elem - m_write_offset);
    unsigned int elems_after_end = num_elem - elems_before_end;
    
    if(elems_before_end)
        memcpy(m_data + m_write_offset * m_data_width,
               data,
               elems_before_end * m_data_width);
    
    if(elems_after_end)
        memcpy(m_data,
               data + elems_before_end * m_data_width,
               elems_after_end * m_data_width);
    
    if(elems_after_end)
        m_write_offset = elems_after_end;
    else
        m_write_offset += elems_before_end;
    
    return elems_before_end + elems_after_end;
}




//-----------------------------------------------------------------------------
// name: get()
// desc: get
//-----------------------------------------------------------------------------
unsigned int FastCircularBuffer::get( void * _data, unsigned int num_elem )
{
    unsigned char * data = (unsigned char *)_data;
    
    unsigned int elems_before_end;
    unsigned int elems_after_end;
    if(m_write_offset < m_read_offset)
    {
        elems_before_end = m_max_elem - m_read_offset;
        elems_after_end = m_write_offset;
    }
    else
    {
        elems_before_end = m_write_offset - m_read_offset;
        elems_after_end = 0;
    }
    
    if(elems_before_end > num_elem)
    {
        elems_before_end = num_elem;
        elems_after_end = 0;
    }
    else if(elems_before_end + elems_after_end > num_elem)
    {
        elems_after_end = num_elem - elems_before_end;
    }
    
    //    UInt32 elems_before_end = min(m_write_offset - m_read_offset, m_max_elem - m_read_offset);
    //    UInt32 elems_after_end = num_elem - elems_before_end;
    
    if(elems_before_end)
        memcpy(data,
               m_data + m_read_offset * m_data_width,
               elems_before_end * m_data_width);
    
    if(elems_after_end)
        memcpy(data + elems_before_end * m_data_width,
               m_data,
               elems_after_end * m_data_width);
    
    if(elems_after_end)
        m_read_offset = elems_after_end;
    else
        m_read_offset += elems_before_end;
    
    return elems_before_end + elems_after_end;
}


