//
//  FastCircularBuffer.h
//  RtSwift
//
//  Created by Spencer Salazar on 4/1/17.
//  Copyright © 2017 Spencer Salazar. All rights reserved.
//

#pragma once

//-----------------------------------------------------------------------------
// name: class FastCircularBuffer
// desc: uses memcpy instead of assignment
//       useful for streaming large blocks of data
//-----------------------------------------------------------------------------
class FastCircularBuffer
{
public:
    FastCircularBuffer();
    ~FastCircularBuffer();
    
public:
    bool initialize( unsigned int num_elem, unsigned int width );
    void cleanup();
    
public:
    unsigned int get( void * data, unsigned int num_elem );
    unsigned int put( void * data, unsigned int num_elem );
    inline bool hasMore() { return (m_read_offset != m_write_offset); }
    inline void clear() { m_read_offset = m_write_offset = 0; }

    inline unsigned int canRead()
    {
        int num = m_write_offset-m_read_offset;
        if(num < 0)
            num += m_max_elem;
        return num;
    }
    
    inline unsigned int canWrite()
    {
        int num = m_read_offset-m_write_offset-1;
        if(num < 0)
            num += m_max_elem;
        return num;
    }
    
protected:
    unsigned char *m_data;
    unsigned int   m_data_width;
    unsigned int   m_read_offset;
    unsigned int   m_write_offset;
    unsigned int   m_max_elem;
};

